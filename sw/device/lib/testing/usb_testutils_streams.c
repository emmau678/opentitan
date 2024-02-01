// Copyright lowRISC contributors (OpenTitan project).
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0
//
// USB streaming utility code
//
// This test code supports a set of concurrent uni/bidirectional streams using
// the Bulk Transfer type, such that all data is delivered reliably to/from the
// USB host.
//
// The data itself is pseudo-randomly generated by the sender and,
// independently, by the receiving code to check that the data has been
// propagated unmodified and without data loss, corruption, replication etc.

#include "sw/device/lib/testing/usb_testutils_streams.h"

#include "sw/device/lib/runtime/print.h"
#include "sw/device/lib/testing/test_framework/check.h"
#include "sw/device/lib/testing/usb_testutils_diags.h"

#define MODULE_ID MAKE_MODULE_ID('u', 't', 's')

/**
 * Read method to be employed
 */
static const enum {
  kReadMethodNone = 0u,  // Just discard the data; do not read it from usbdev
  kReadMethodStandard,   // Use standard dif_usbdev_buffer_read() function
  kReadMethodFaster      // Faster implementation
} read_method = kReadMethodStandard;

/**
 * Write method to be employed
 */
static const enum {
  kWriteMethodStandard = 1u,  // Use standard dif_usbdev_buffer_write() function
  kWriteMethodFaster          // Faster implementation
} write_method = kWriteMethodStandard;

/**
 * Diagnostic logging; expensive
 */
static bool log_traffic = false;

// Determine the length of the next packet in the data stream, _including_
// any required signature.
static uint8_t packet_length(const usbdev_stream_t *s, uint32_t bytes_done,
                             uint8_t *bufsz_lfsr) {
  // For non-Isochronous streams the packet size is also constrained by the
  // total size of the transfer. For Isochronous streams we just keep
  // transmitting to account for the possibility of packet loss.
  uint8_t bytes_left = USBDEV_MAX_PACKET_SIZE;

  if (s->xfr_type != kUsbTransferTypeIsochronous) {
    if (bytes_done < s->transfer_bytes &&
        s->transfer_bytes - bytes_done < bytes_left) {
      bytes_left = (uint8_t)(s->transfer_bytes - bytes_done);
    }
  }

  // Length of packet
  unsigned num_bytes;

  if (s->flags & kUsbdevStreamFlagMaxPackets) {
    num_bytes = bytes_left;
  } else {
    // Vary the amount of data sent per buffer
    if (s->tx.sig_required) {
      const unsigned sig_bytes = sizeof(usbdev_stream_sig_t);
      switch (s->xfr_type) {
        case kUsbTransferTypeIsochronous: {
          // For Isochronous streams, and the first packet of other transfers,
          // we must constrain the minimum packet size
          const unsigned max_bytes = USBDEV_MAX_PACKET_SIZE - sig_bytes;
          num_bytes = sig_bytes + (*bufsz_lfsr % (max_bytes + 1u));
        } break;
        default:
          num_bytes = sig_bytes;
          break;
      }
    } else {
      num_bytes = *bufsz_lfsr % (bytes_left + 1u);
    }
    *bufsz_lfsr = LFSR_ADVANCE(*bufsz_lfsr);
  }

  return (uint8_t)num_bytes;
}

// Dump a sequence of bytes as hexadecimal and ASCII for diagnostic purposes
static void buffer_dump(const uint8_t *data, size_t n) {
  base_hexdump_fmt_t fmt = {
      .bytes_per_word = 1,
      .words_per_line = 0x20u,
      .alphabet = &kBaseHexdumpDefaultFmtAlphabet,
  };

  base_hexdump_with(fmt, (char *)data, n);
}

// Create a stream signature buffer
static uint8_t buffer_sig_create(usb_testutils_streams_ctx_t *ctx,
                                 usbdev_stream_t *s, dif_usbdev_buffer_t *buf) {
  // Number of bytes left to be transmitted
  // - for non-Isochronous streams this is just the total number of bytes to be
  //   transmitted, and there's a single signature at the start of the stream
  // - for Isochronous this provideds a down count, and it will wrap around
  //   upon reaching zero, in the event of packet loss and prolonged
  //   transmission
  uint32_t tx_left = s->transfer_bytes - (s->tx.bytes % s->transfer_bytes);

  usbdev_stream_sig_t sig;
  sig.head_sig = USBDEV_STREAM_SIGNATURE_HEAD;
  sig.init_lfsr = s->tx.lfsr;
  sig.stream = s->id | (uint8_t)s->flags;
  sig.seq_lo = (uint8_t)s->tx.seq;
  sig.seq_hi = (uint8_t)(s->tx.seq >> 8);
  sig.num_bytes = tx_left;
  sig.tail_sig = USBDEV_STREAM_SIGNATURE_TAIL;

  // Advance sequence counter
  s->tx.seq++;

  if (s->verbose && log_traffic) {
    buffer_dump((uint8_t *)&sig, sizeof(sig));
  }

  size_t bytes_written;
  switch (write_method) {
#if USBUTILS_MEM_FASTER
    case kWriteMethodFaster:
      // TODO: integrate faster transfers to/from USB device packet buffer
      // memory.
      OT_FALLTHROUGH_INTENDED;
#endif
    default:
      CHECK_DIF_OK(dif_usbdev_buffer_write(
          ctx->usbdev->dev, buf, (uint8_t *)&sig, sizeof(sig), &bytes_written));
      CHECK(bytes_written == sizeof(sig));
      break;
  }

  // Note: stream signature is not included in the count of bytes transferred
  // so we do not advance tx_bytes
  return (uint8_t)bytes_written;
}

// Check a stream signature
//
// Note: Only Isochronous streams are expected to receive signatures; in order
// to keep the device and host ends synchronized in the presence of packet-
// dropping, a signature occurs at the start of each packet. Each signature
// includes a packet sequence number and the intiial value of the sender's LFSR
static bool buffer_sig_check(usb_testutils_streams_ctx_t *ctx,
                             usbdev_stream_t *s, const usbdev_stream_sig_t *sig,
                             uint8_t len) {
  // Validate the signature
  if (sig->head_sig != USBDEV_STREAM_SIGNATURE_HEAD ||
      sig->tail_sig != USBDEV_STREAM_SIGNATURE_TAIL ||
      // Returned to the correct stream?
      (sig->stream & 0xfU) != s->id) {
    LOG_INFO("buffer_sig_check failed: ");
    return false;
  }

  // Sequence number not regressed?
  uint16_t seq = (uint16_t)((sig->seq_hi << 8) | sig->seq_lo);
  if (seq < s->rx_seq) {
    LOG_INFO("buffer_sig_check: sequence number regressed from 0x%x to 0x%x",
             s->rx_seq, seq);
    return false;
  }

  // Current LFSR state and sequence number
  uint16_t rx_seq = s->rx_seq;
  uint8_t rx_lfsr = s->rx_lfsr;
  uint8_t rxtx_lfsr = s->rxtx_lfsr;

  // Skip past any packets that appear to have been dropped; this is
  // permissible for Isochronous transfers which prioritize service/real-time
  // delivery over reliable transmission.
  if (rx_seq < seq) {
    do {
      // Determine the length of the missing packet
      uint8_t len = packet_length(s, s->rx_bytes, &s->rx_buf_size);
      len -= sizeof(*sig);
      // Advance the LFSR states to account for the missing packet
      while (len-- > 0U) {
        rxtx_lfsr = LFSR_ADVANCE(rxtx_lfsr);
      }
      // The updated host-side LFSR has been supplied in the packet signature
      rx_seq++;
    } while (rx_seq < seq);

    // Since we do not know where the packet(s) were dropped, we must set our
    // knowledge of the host-side LFSR to the value indicated in this packet.
    rx_lfsr = sig->init_lfsr;
  }

  // Our expectation of the host/DPI LFSR should now match the value that it has
  // supplied in the modified packet.
  if (rx_lfsr != sig->init_lfsr) {
    LOG_INFO(
        "buffer_sig_check: S%u unexpected host-side LFSR value (0x%x but "
        "expected 0x%x)",
        s->id, sig->init_lfsr, rx_lfsr);
    return false;
  }

  // For 'rx_buf_size' to track the 'tx_buf_size' used when the packets were
  // created and transmitted, we must also ascertain the expected length of the
  // packet that we have just received; we thus check that the length of this
  // packet has not changed either.
  uint8_t exp_len = packet_length(s, s->rx_bytes, &s->rx_buf_size);
  if (len != exp_len) {
    LOG_INFO(
        "buffer_sig_check: S%u unexpected packet length (0x%x but expected "
        "0x%x)",
        s->id, len, exp_len);
    return false;
  }

  // Expected sequence number of next packet
  s->rx_seq = rx_seq + 1U;
  // Update the LFSR states
  s->rxtx_lfsr = rxtx_lfsr;
  s->rx_lfsr = rx_lfsr;

  return true;
}

// Fill a buffer with LFSR-generated data
static void buffer_fill(usb_testutils_streams_ctx_t *ctx, usbdev_stream_t *s,
                        dif_usbdev_buffer_t *buf, uint8_t num_bytes) {
  alignas(uint32_t) uint8_t data[USBDEV_MAX_PACKET_SIZE];

  CHECK(num_bytes <= buf->remaining_bytes);
  CHECK(num_bytes <= sizeof(data));

  if (s->generating) {
    // Emit LFSR-generated byte stream; keep this brief so that we can
    // reduce our latency in responding to USB events (usb_testutils employs
    // polling at present)
    uint8_t lfsr = s->tx.lfsr;

    const uint8_t *edp = &data[num_bytes];
    uint8_t *dp = data;
    while (dp < edp) {
      *dp++ = lfsr;
      lfsr = LFSR_ADVANCE(lfsr);
    }

    // Update the LFSR for the next packet
    s->tx.lfsr = lfsr;
  } else {
    // Undefined buffer contents; useful for profiling IN throughput on
    // CW310, because the CPU load at 10MHz can be an appreciable slowdown
  }

  if (s->verbose && log_traffic) {
    buffer_dump(data, num_bytes);
  }

  size_t bytes_written;
  switch (write_method) {
#if USBUTILS_MEM_FASTER
    case kWriteMethodFaster:
      // TODO: integrate faster transfers to/from USB device packet buffer
      // memory.
      OT_FALLTHROUGH_INTENDED;
#endif
    default:
      CHECK_DIF_OK(dif_usbdev_buffer_write(ctx->usbdev->dev, buf, data,
                                           num_bytes, &bytes_written));
      CHECK(bytes_written == num_bytes);
      break;
  }
  s->tx.bytes += bytes_written;
}

// Check the contents of a received buffer
static void buffer_check(usb_testutils_streams_ctx_t *ctx, usbdev_stream_t *s,
                         dif_usbdev_rx_packet_info_t packet_info,
                         dif_usbdev_buffer_t buf) {
  usb_testutils_ctx_t *usbdev = ctx->usbdev;
  uint8_t len = packet_info.length;

  if (len > 0) {
    alignas(uint32_t) uint8_t data[USBDEV_MAX_PACKET_SIZE];

    CHECK(len <= sizeof(data));

    // Notes: the buffer being read here is USBDEV memory accessed as MMIO, so
    //        only the DIF accesses it directly. when we consume the final bytes
    //        from the read buffer, it is automatically returned to the buffer
    //        pool.

    size_t bytes_read;
    switch (read_method) {
#if USBUTILS_MEM_FASTER
      // Faster read performance using custom routine
      case kReadMethodFaster:
        // TODO: faster read method not yet integrated, defaulting to standard
        OT_FALLTHROUGH_INTENDED;
#endif
      default:
        CHECK_DIF_OK(dif_usbdev_buffer_read(usbdev->dev, usbdev->buffer_pool,
                                            &buf, data, len, &bytes_read));
        break;
    }
    CHECK(bytes_read == len);

    if (s->verbose && log_traffic) {
      buffer_dump(data, bytes_read);
    }

    // Byte offset of LFSR-generated byte stream
    size_t offset = 0U;

    switch (s->xfr_type) {
      case kUsbTransferTypeIsochronous: {
        // Check the packet signature, advance the LFSRs and drop through to
        // check the remainder of the packet
        const usbdev_stream_sig_t *sig = (usbdev_stream_sig_t *)data;
        bool ok = buffer_sig_check(ctx, s, sig, len);
        CHECK(ok, "S%u: Received packet invalid", s->id);

        offset = sizeof(*sig);
      }  // no break
        OT_FALLTHROUGH_INTENDED;
      case kUsbTransferTypeInterrupt:
        OT_FALLTHROUGH_INTENDED;
      case kUsbTransferTypeBulk: {
        // Check received data against expected LFSR-generated byte stream;
        // keep this brief so that we can reduce our latency in responding to
        // USB events (usb_testutils employs polling at present)
        uint8_t rxtx_lfsr = s->rxtx_lfsr;
        uint8_t rx_lfsr = s->rx_lfsr;

        const uint8_t *esp = &data[bytes_read];
        const uint8_t *sp = &data[offset];
        while (sp < esp) {
          // Received data should be the XOR of two LFSR-generated PRND streams
          // - ours on the transmission side, and that of the DPI model
          uint8_t expected = rxtx_lfsr ^ rx_lfsr;
          CHECK(expected == *sp,
                "S%u: Unexpected received data 0x%02x : (LFSRs 0x%02x 0x%02x)",
                s->id, *sp, rxtx_lfsr, rx_lfsr);

          rxtx_lfsr = LFSR_ADVANCE(rxtx_lfsr);
          rx_lfsr = LFSR_ADVANCE(rx_lfsr);
          sp++;
        }

        // Update the LFSRs for the next packet
        s->rxtx_lfsr = rxtx_lfsr;
        s->rx_lfsr = rx_lfsr;

        // Update the count of LFSR bytes received
        s->rx_bytes += bytes_read - offset;
      } break;

      default:
        CHECK(s->xfr_type == kUsbTransferTypeControl);
        break;
    }
  } else {
    // In the event that we've received a zero-length data packet, we still
    // must return the buffer to the pool
    CHECK_DIF_OK(
        dif_usbdev_buffer_return(usbdev->dev, usbdev->buffer_pool, &buf));
  }
}

// Callback for successful buffer transmission
static status_t strm_tx_done(void *cb_v, usb_testutils_xfr_result_t result) {
  // Pointer to callback context.
  usbdev_stream_cb_ctx_t *cb = (usbdev_stream_cb_ctx_t *)cb_v;
  // Streaming context and per-stream context.
  usb_testutils_streams_ctx_t *ctx = cb->ctx;
  usbdev_stream_t *s = cb->s;

  // If we do not have at least one queued buffer then something has gone wrong
  // and this callback is inappropriate
  uint8_t tx_ep = s->tx_ep;
  uint8_t nqueued = ctx->tx_bufs_queued[tx_ep];

  if (s->verbose) {
    LOG_INFO("strm_tx_done called. %u (%u total) buffers(s) are queued",
             nqueued, ctx->tx_queued_total);
  }

  TRY_CHECK(nqueued > 0);

  // Note: since buffer transmission and completion signalling both occur within
  // the foreground code (polling, not interrupt-driven) there is no issue of
  // potential races here

  if (nqueued > 0) {
    // Advance the 'committed transmission' state for this stream
    s->tx_cmt = ctx->tx_bufs[tx_ep][0u].tx;

    // Shuffle the buffer descriptions, without using memmove
    for (unsigned idx = 1u; idx < nqueued; idx++) {
      ctx->tx_bufs[tx_ep][idx - 1u] = ctx->tx_bufs[tx_ep][idx];
    }

    // Is there another buffer ready to be transmitted?
    ctx->tx_queued_total--;
    ctx->tx_bufs_queued[tx_ep] = --nqueued;

    if (nqueued) {
      usb_testutils_ctx_t *usbdev = ctx->usbdev;
      TRY(dif_usbdev_send(usbdev->dev, tx_ep, &ctx->tx_bufs[tx_ep][0u].buf));
    }
  }
  return OK_STATUS();
}

// Callback for buffer reception
static status_t strm_rx(void *cb_v, dif_usbdev_rx_packet_info_t packet_info,
                        dif_usbdev_buffer_t buf) {
  // Pointer to callback context.
  usbdev_stream_cb_ctx_t *cb = (usbdev_stream_cb_ctx_t *)cb_v;
  // Streaming context and per-stream context.
  usb_testutils_streams_ctx_t *ctx = cb->ctx;
  usbdev_stream_t *s = cb->s;

  TRY_CHECK(packet_info.endpoint == s->rx_ep);

  // We do not expect to receive SETUP packets to this endpoint
  TRY_CHECK(!packet_info.is_setup);

  if (s->verbose) {
    LOG_INFO("Stream %u: Received buffer of %u bytes(s)", s->id,
             packet_info.length);
  }

  if (s->sending && s->generating) {
    buffer_check(ctx, s, packet_info, buf);
  } else {
    // Note: this is useful for profiling the OUT performance on CW310
    usb_testutils_ctx_t *usbdev = ctx->usbdev;

    if (read_method != kReadMethodNone && packet_info.length > 0) {
      alignas(uint32_t) uint8_t data[USBDEV_MAX_PACKET_SIZE];
      size_t len = packet_info.length;
      size_t bytes_read;

      switch (read_method) {
#if USBUTILS_MEM_FASTER
        // Faster read performance using custom routine
        case kReadMethodFaster:
          // TODO: faster read method not yet integrated, defaulting to standard
          OT_FALLTHROUGH_INTENDED;
#endif
        //  Use the standard interface
        default:
          TRY(dif_usbdev_buffer_read(usbdev->dev, usbdev->buffer_pool, &buf,
                                     data, len, &bytes_read));
          break;
      }
    } else {
      // Just discard the data, without reading it; peak OUT performance
      TRY(dif_usbdev_buffer_return(usbdev->dev, usbdev->buffer_pool, &buf));
    }

    s->rx_bytes += packet_info.length;
  }

  return OK_STATUS();
}

// Set the count of already-initialized streams, and apportion the available
// tx buffers among the streams.
bool usb_testutils_streams_count_set(usb_testutils_streams_ctx_t *ctx,
                                     unsigned nstreams) {
  // Too many streams?
  if (nstreams > USBUTILS_STREAMS_MAX) {
    return false;
  }

  // Decide how many buffers each endpoint may queue up for transmission;
  // we must ensure that there are buffers available for reception, and we
  // do not want any endpoint to starve another
  for (unsigned s = 0U; s < nstreams; s++) {
    // This is slightly overspending the available buffers, leaving the
    //   endpoints to vie for the final few buffers, so it's important that
    //   we limit the total number of buffers across all endpoints too
    unsigned ep = ctx->streams[s].tx_ep;
    ctx->tx_bufs_queued[ep] = 0U;
    ctx->tx_bufs_limit[ep] =
        (uint8_t)((USBUTILS_STREAMS_TXBUF_MAX + nstreams - 1) / nstreams);
  }
  ctx->tx_queued_total = 0U;

  // Remember the stream count
  ctx->nstreams = (uint8_t)nstreams;

  return true;
}

// Returns an indication of whether a stream has completed its data transfer
bool usb_testutils_stream_completed(const usb_testutils_streams_ctx_t *ctx,
                                    uint8_t id) {
  // Locate the stream context information
  const usbdev_stream_t *s = &ctx->streams[id];

  return (s->tx.bytes >= s->transfer_bytes) &&
         (s->rx_bytes >= s->transfer_bytes);
}

// Initialize a stream, preparing it for use
status_t usb_testutils_stream_init(usb_testutils_streams_ctx_t *ctx, uint8_t id,
                                   usb_testutils_transfer_type_t xfr_type,
                                   uint8_t ep_in, uint8_t ep_out,
                                   uint32_t transfer_bytes,
                                   usbdev_stream_flags_t flags, bool verbose) {
  // Locate the stream context information
  TRY_CHECK(id < USBUTILS_STREAMS_MAX);
  usbdev_stream_t *s = &ctx->streams[id];

  // Remember the stream IDentifier and flags
  s->id = id;
  s->flags = flags;

  // Remember the stream transfer type
  s->xfr_type = xfr_type;

  // Remember whether verbose reporting is required
  s->verbose = verbose;

  // Extract a couple of convenient flags; from our perspective
  s->sending = ((flags & kUsbdevStreamFlagRetrieve) != 0U);
  s->generating = ((flags & kUsbdevStreamFlagCheck) != 0U);

  // Not yet sent stream signature
  s->tx.sig_required = true;

  // Initialize the transfer state
  s->tx.bytes = 0u;
  s->rx_bytes = 0u;
  s->transfer_bytes = transfer_bytes;

  // Sequence number to be used for first packet
  s->tx.seq = 0u;
  s->rx_seq = s->tx.seq;

  // Initialize the LFSR state for transmission and reception sides
  // - we use a simple LFSR to generate a PRND stream to transmit to the USBPI
  // - the USBDPI XORs the received data with another LFSR-generated stream of
  //   its own, and transmits the result back to us
  // - to check the returned data, our reception code mimics both LFSRs
  s->tx.lfsr = USBTST_LFSR_SEED(id);
  s->rxtx_lfsr = s->tx.lfsr;
  s->rx_lfsr = USBDPI_LFSR_SEED(id);

  // Packet size randomization
  s->tx.buf_size = BUFSZ_LFSR_SEED(id);
  s->rx_buf_size = s->tx.buf_size;

  s->rx_ep = ep_out;
  s->tx_ep = ep_in;

  // Retain the current transmission state as the latest 'committed transmission
  // state'
  s->tx_cmt = s->tx;

  // Callback context pointer; permits access to both the stream-specific state
  // and the enclosing streaming context.
  usbdev_stream_cb_ctx_t *cb = &ctx->cb[id];
  cb->ctx = ctx;
  cb->s = s;

  // Set up the endpoint for IN transfers (TO host)
  CHECK_STATUS_OK(usb_testutils_in_endpoint_setup(
      ctx->usbdev, ep_in, xfr_type, cb, strm_tx_done, NULL, NULL));

  // Set up the endpoint for OUT transfers (FROM host)
  CHECK_STATUS_OK(usb_testutils_out_endpoint_setup(
      ctx->usbdev, ep_out, xfr_type, kUsbdevOutStream, cb, strm_rx, NULL));

  return OK_STATUS();
}

// Service the given stream, preparing and/or sending any data that we can;
// data reception is handled via callbacks and requires no attention here
status_t usb_testutils_stream_service(usb_testutils_streams_ctx_t *ctx,
                                      uint8_t id) {
  // Locate the stream context information
  TRY_CHECK(id < USBUTILS_STREAMS_MAX);
  usbdev_stream_t *s = &ctx->streams[id];

  // Generate output data as soon as possible and make it available for
  //   collection by the host

  uint8_t tx_ep = s->tx_ep;
  uint8_t nqueued = ctx->tx_bufs_queued[tx_ep];

  // Isochronous streams never cease transmission because packets are expected
  // to get dropped; let the reception side decided test completion
  bool tx_more = (s->xfr_type == kUsbTransferTypeIsochronous) ||
                 (s->tx.bytes < s->transfer_bytes);

  if (tx_more &&                              // More bytes to transfer?
      nqueued < ctx->tx_bufs_limit[tx_ep] &&  // Endpoint allowed buffer?
      ctx->tx_queued_total <
          USBUTILS_STREAMS_TXBUF_MAX) {  // Total buffers not exceeded?
    dif_usbdev_buffer_t buf;

    // See whether we can populate another buffer yet
    dif_result_t dif_result = dif_usbdev_buffer_request(
        ctx->usbdev->dev, ctx->usbdev->buffer_pool, &buf);
    if (dif_result == kDifOk) {
      // This is just for reporting the number of buffers presented to the
      // USB device, as a progress indicator
      static unsigned bufs_sent = 0u;
      uint8_t bytes_added = 0u;
      uint8_t num_bytes;

      // Decide upon the packet length, _including_ any signature bytes.
      num_bytes = packet_length(s, s->tx.bytes, &s->tx.buf_size);

      // Construct a signature to send to the host-side software,
      // identifying the stream and its properties?
      if (s->tx.sig_required) {
        bytes_added = buffer_sig_create(ctx, s, &buf);
        // If we're 'not sending' then we still send the stream signature once
        // but only the signature; it allows the host/DPI model to receive the
        // stream flags and discover that no further data is to be expected.
        if (!s->sending) {
          s->tx.bytes = s->transfer_bytes;
        }
        // Signature required for each packet of an Isochronous stream, but only
        // at the stream start for other transfer types
        if (!s->sending || s->xfr_type != kUsbTransferTypeIsochronous) {
          // First packet is just the stream signature
          s->tx.sig_required = false;
        }
      }

      // How many LFSR-generated bytes are to be included?
      if (bytes_added < num_bytes) {
        buffer_fill(ctx, s, &buf, (uint8_t)(num_bytes - bytes_added));
      }

      // Remember the buffer and the current transmission state until we're
      // informed that it has been successfully transmitted
      //
      // Note: since the 'tx_done' callback occurs from foreground code that
      // is polling, there is no issue of interrupt races here
      ctx->tx_bufs[tx_ep][nqueued].buf = buf;
      ctx->tx_bufs[tx_ep][nqueued].tx = s->tx;
      ctx->tx_bufs_queued[tx_ep] = ++nqueued;
      ctx->tx_queued_total++;

      // Can we present this buffer for transmission yet?
      if (nqueued <= 1U) {
        TRY(dif_usbdev_send(ctx->usbdev->dev, tx_ep, &buf));
      }

      if (s->verbose) {
        LOG_INFO(
            "Stream %u: %uth buffer (of 0x%x byte(s)) awaiting transmission",
            s->id, bufs_sent, num_bytes);
      }
      bufs_sent++;
    } else {
      // If we have no more buffers available right now, continue polling...
      CHECK(dif_result == kDifUnavailable);
    }
  }
  return OK_STATUS();
}

status_t usb_testutils_streams_init(usb_testutils_streams_ctx_t *ctx,
                                    unsigned nstreams,
                                    usb_testutils_transfer_type_t xfr_types[],
                                    uint32_t num_bytes,
                                    usbdev_stream_flags_t flags, bool verbose) {
  TRY_CHECK(nstreams <= USBUTILS_STREAMS_MAX);
  TRY_CHECK(nstreams <= UINT8_MAX);

  // Initialize the state of each stream
  for (uint8_t id = 0U; id < nstreams; id++) {
    // Which endpoint are we using for the IN transfers to the host?
    const uint8_t ep_in = id + 1U;
    // Which endpoint are we using for the OUT transfers from the host?
    const uint8_t ep_out = id + 1U;
    TRY(usb_testutils_stream_init(ctx, id, xfr_types[id], ep_in, ep_out,
                                  num_bytes, flags, verbose));
  }

  // Remember the stream count and apportion the available tx buffers
  TRY_CHECK(usb_testutils_streams_count_set(ctx, nstreams));

  return OK_STATUS();
}

status_t usb_testutils_streams_service(usb_testutils_streams_ctx_t *ctx) {
  TRY_CHECK(ctx->nstreams <= UINT8_MAX);

  for (uint8_t id = 0U; id < ctx->nstreams; id++) {
    TRY(usb_testutils_stream_service(ctx, id));

    // We must keep polling regularly in order to handle detection of packet
    // transmission as well as perform packet reception and checking
    CHECK_STATUS_OK(usb_testutils_poll(ctx->usbdev));
  }
  return OK_STATUS();
}

status_t usb_testutils_streams_suspend(usb_testutils_streams_ctx_t *ctx,
                                       uint8_t *buf, unsigned size,
                                       unsigned *used) {
  // Validate arguments.
  if (!ctx || !buf || !used ||
      size < 1U + ctx->nstreams * sizeof(usbdev_stream_t)) {
    return INVALID_ARGUMENT();
  }

  // Store the stream count
  uint8_t *dp = buf;
  *dp++ = ctx->nstreams;

  // Store the state of each stream
  for (uint8_t id = 0U; id < ctx->nstreams; id++) {
    // We can just save the entire stream context as-is
    const usbdev_stream_t *s = &ctx->streams[id];
    memcpy(dp, s, sizeof(*s));
    dp += sizeof(*s);
    if (s->verbose) {
      LOG_INFO("S%u: suspend seq %u, lfsr %x <- commit seq %u, lfsr %x", id,
               s->tx.seq, s->tx.lfsr, s->tx_cmt.seq, s->tx_cmt.lfsr);
    }
  }

  *used = (unsigned)(dp - buf);

  // Note: we rely upon all packet reception having occurred, such that there
  // are no residual OUT data packets in the USB device. There is necessarily a
  // period of at least 4ms of Suspending/Suspended state before we save the
  // state for Sleep.
  // In practice it is likely to be much longer than that.

  return OK_STATUS();
}

status_t usb_testutils_streams_resume(usb_testutils_streams_ctx_t *ctx,
                                      const uint8_t *data, unsigned len) {
  // Validate arguments.
  if (!ctx || !data || len < 1U) {
    return INVALID_ARGUMENT();
  }

  // We expect only to be resuming immediately after initialization, and with no
  // buffers already in use.
  if (ctx->tx_queued_total) {
    return FAILED_PRECONDITION();
  }

  // Read the stream count and then check that we have enough supplied data.
  const uint8_t *dp = data;
  unsigned nstreams = *dp++;
  if (len < 1U + nstreams * sizeof(usbdev_stream_t)) {
    return INVALID_ARGUMENT();
  }

  for (uint8_t id = 0U; id < nstreams; id++) {
    // Load the entire stream context as-is...
    usbdev_stream_t *s = &ctx->streams[id];
    memcpy(&s->id, dp, sizeof(*s));
    if (s->verbose) {
      LOG_INFO("S%u: resume seq %u, lfsr %x <- commit seq %u, lfsr %x", id,
               s->tx.seq, s->tx.lfsr, s->tx_cmt.seq, s->tx_cmt.lfsr);
    }
    // ...but now we need to rewind the state to the latest 'commit' point,
    // reflecting the most recent point of data transmission at the USB device,
    // rather than the point to which the packet creation had run ahead.
    s->tx = s->tx_cmt;
    dp += sizeof(*s);
  }

  // Remember the stream count and apportion the available tx buffers
  TRY_CHECK(usb_testutils_streams_count_set(ctx, nstreams));

  return OK_STATUS();
}

status_t usb_testutils_stream_status(usb_testutils_streams_ctx_t *ctx,
                                     uint8_t id, uint32_t *num_bytes,
                                     uint32_t *tx_bytes, uint32_t *rx_bytes) {
  // Check the stream IDentifier.
  if (id >= ctx->nstreams) {
    return INVALID_ARGUMENT();
  }

  // Return the requested information.
  const usbdev_stream_t *s = &ctx->streams[id];
  if (num_bytes) {
    *num_bytes = s->transfer_bytes;
  }
  if (tx_bytes) {
    *tx_bytes = s->tx.bytes;
  }
  if (rx_bytes) {
    *rx_bytes = s->rx_bytes;
  }

  return OK_STATUS();
}

bool usb_testutils_streams_completed(const usb_testutils_streams_ctx_t *ctx) {
  // See whether any streams still have more work to do
  for (uint8_t id = 0; id < ctx->nstreams; id++) {
    if (!usb_testutils_stream_completed(ctx, id)) {
      return false;
    }
  }
  return true;
}
