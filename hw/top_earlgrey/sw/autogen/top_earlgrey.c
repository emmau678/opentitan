// Copyright lowRISC contributors.
// Licensed under the Apache License, Version 2.0, see LICENSE for details.
// SPDX-License-Identifier: Apache-2.0

#include "hw/top_earlgrey/sw/autogen/top_earlgrey.h"

/**
 * PLIC Interrupt Source to Peripheral Map
 *
 * This array is a mapping from `top_earlgrey_plic_irq_id_t` to
 * `top_earlgrey_plic_peripheral_t`.
 */
const top_earlgrey_plic_peripheral_t
    top_earlgrey_plic_interrupt_for_peripheral[180] = {
  [kTopEarlgreyPlicIrqIdNone] = kTopEarlgreyPlicPeripheralUnknown,
  [kTopEarlgreyPlicIrqIdUart0TxWatermark] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxWatermark] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0TxEmpty] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxOverflow] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxFrameErr] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxBreakErr] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxTimeout] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart0RxParityErr] = kTopEarlgreyPlicPeripheralUart0,
  [kTopEarlgreyPlicIrqIdUart1TxWatermark] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxWatermark] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1TxEmpty] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxOverflow] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxFrameErr] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxBreakErr] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxTimeout] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart1RxParityErr] = kTopEarlgreyPlicPeripheralUart1,
  [kTopEarlgreyPlicIrqIdUart2TxWatermark] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxWatermark] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2TxEmpty] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxOverflow] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxFrameErr] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxBreakErr] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxTimeout] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart2RxParityErr] = kTopEarlgreyPlicPeripheralUart2,
  [kTopEarlgreyPlicIrqIdUart3TxWatermark] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxWatermark] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3TxEmpty] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxOverflow] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxFrameErr] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxBreakErr] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxTimeout] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdUart3RxParityErr] = kTopEarlgreyPlicPeripheralUart3,
  [kTopEarlgreyPlicIrqIdGpioGpio0] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio1] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio2] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio3] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio4] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio5] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio6] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio7] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio8] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio9] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio10] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio11] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio12] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio13] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio14] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio15] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio16] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio17] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio18] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio19] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio20] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio21] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio22] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio23] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio24] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio25] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio26] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio27] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio28] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio29] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio30] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdGpioGpio31] = kTopEarlgreyPlicPeripheralGpio,
  [kTopEarlgreyPlicIrqIdSpiDeviceRxf] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiDeviceRxlvl] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiDeviceTxlvl] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiDeviceRxerr] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiDeviceRxoverflow] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiDeviceTxunderflow] = kTopEarlgreyPlicPeripheralSpiDevice,
  [kTopEarlgreyPlicIrqIdSpiHost0Error] = kTopEarlgreyPlicPeripheralSpiHost0,
  [kTopEarlgreyPlicIrqIdSpiHost0SpiEvent] = kTopEarlgreyPlicPeripheralSpiHost0,
  [kTopEarlgreyPlicIrqIdSpiHost1Error] = kTopEarlgreyPlicPeripheralSpiHost1,
  [kTopEarlgreyPlicIrqIdSpiHost1SpiEvent] = kTopEarlgreyPlicPeripheralSpiHost1,
  [kTopEarlgreyPlicIrqIdI2c0FmtWatermark] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0RxWatermark] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0FmtOverflow] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0RxOverflow] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0Nak] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0SclInterference] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0SdaInterference] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0StretchTimeout] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0SdaUnstable] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0TransComplete] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0TxEmpty] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0TxNonempty] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0TxOverflow] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0AcqOverflow] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0AckStop] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c0HostTimeout] = kTopEarlgreyPlicPeripheralI2c0,
  [kTopEarlgreyPlicIrqIdI2c1FmtWatermark] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1RxWatermark] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1FmtOverflow] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1RxOverflow] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1Nak] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1SclInterference] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1SdaInterference] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1StretchTimeout] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1SdaUnstable] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1TransComplete] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1TxEmpty] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1TxNonempty] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1TxOverflow] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1AcqOverflow] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1AckStop] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c1HostTimeout] = kTopEarlgreyPlicPeripheralI2c1,
  [kTopEarlgreyPlicIrqIdI2c2FmtWatermark] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2RxWatermark] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2FmtOverflow] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2RxOverflow] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2Nak] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2SclInterference] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2SdaInterference] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2StretchTimeout] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2SdaUnstable] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2TransComplete] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2TxEmpty] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2TxNonempty] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2TxOverflow] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2AcqOverflow] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2AckStop] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdI2c2HostTimeout] = kTopEarlgreyPlicPeripheralI2c2,
  [kTopEarlgreyPlicIrqIdPattgenDoneCh0] = kTopEarlgreyPlicPeripheralPattgen,
  [kTopEarlgreyPlicIrqIdPattgenDoneCh1] = kTopEarlgreyPlicPeripheralPattgen,
  [kTopEarlgreyPlicIrqIdRvTimerTimerExpired0_0] = kTopEarlgreyPlicPeripheralRvTimer,
  [kTopEarlgreyPlicIrqIdUsbdevPktReceived] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevPktSent] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevDisconnected] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevHostLost] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevLinkReset] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevLinkSuspend] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevLinkResume] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevAvEmpty] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevRxFull] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevAvOverflow] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevLinkInErr] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevRxCrcErr] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevRxPidErr] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevRxBitstuffErr] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevFrame] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevConnected] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdUsbdevLinkOutErr] = kTopEarlgreyPlicPeripheralUsbdev,
  [kTopEarlgreyPlicIrqIdOtpCtrlOtpOperationDone] = kTopEarlgreyPlicPeripheralOtpCtrl,
  [kTopEarlgreyPlicIrqIdOtpCtrlOtpError] = kTopEarlgreyPlicPeripheralOtpCtrl,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassa] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassb] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassc] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassd] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdPwrmgrAonWakeup] = kTopEarlgreyPlicPeripheralPwrmgrAon,
  [kTopEarlgreyPlicIrqIdSysrstCtrlAonSysrstCtrl] = kTopEarlgreyPlicPeripheralSysrstCtrlAon,
  [kTopEarlgreyPlicIrqIdAdcCtrlAonDebugCable] = kTopEarlgreyPlicPeripheralAdcCtrlAon,
  [kTopEarlgreyPlicIrqIdAonTimerAonWkupTimerExpired] = kTopEarlgreyPlicPeripheralAonTimerAon,
  [kTopEarlgreyPlicIrqIdAonTimerAonWdogTimerBark] = kTopEarlgreyPlicPeripheralAonTimerAon,
  [kTopEarlgreyPlicIrqIdFlashCtrlProgEmpty] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlProgLvl] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlRdFull] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlRdLvl] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlOpDone] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlErr] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdHmacHmacDone] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdHmacFifoEmpty] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdHmacHmacErr] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdKmacKmacDone] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdKmacFifoEmpty] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdKmacKmacErr] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdKeymgrOpDone] = kTopEarlgreyPlicPeripheralKeymgr,
  [kTopEarlgreyPlicIrqIdCsrngCsCmdReqDone] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsEntropyReq] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsHwInstExc] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsFatalErr] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdEntropySrcEsEntropyValid] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEntropySrcEsHealthTestFailed] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEntropySrcEsObserveFifoReady] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEntropySrcEsFatalErr] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEdn0EdnCmdReqDone] = kTopEarlgreyPlicPeripheralEdn0,
  [kTopEarlgreyPlicIrqIdEdn0EdnFatalErr] = kTopEarlgreyPlicPeripheralEdn0,
  [kTopEarlgreyPlicIrqIdEdn1EdnCmdReqDone] = kTopEarlgreyPlicPeripheralEdn1,
  [kTopEarlgreyPlicIrqIdEdn1EdnFatalErr] = kTopEarlgreyPlicPeripheralEdn1,
  [kTopEarlgreyPlicIrqIdOtbnDone] = kTopEarlgreyPlicPeripheralOtbn,
};


/**
 * Alert Handler Alert Source to Peripheral Map
 *
 * This array is a mapping from `top_earlgrey_alert_id_t` to
 * `top_earlgrey_alert_peripheral_t`.
 */
const top_earlgrey_alert_peripheral_t
    top_earlgrey_alert_for_peripheral[40] = {
  [kTopEarlgreyAlertIdSpiHost0FatalFault] = kTopEarlgreyAlertPeripheralSpiHost0,
  [kTopEarlgreyAlertIdSpiHost1FatalFault] = kTopEarlgreyAlertPeripheralSpiHost1,
  [kTopEarlgreyAlertIdOtpCtrlFatalMacroError] = kTopEarlgreyAlertPeripheralOtpCtrl,
  [kTopEarlgreyAlertIdOtpCtrlFatalCheckError] = kTopEarlgreyAlertPeripheralOtpCtrl,
  [kTopEarlgreyAlertIdLcCtrlFatalProgError] = kTopEarlgreyAlertPeripheralLcCtrl,
  [kTopEarlgreyAlertIdLcCtrlFatalStateError] = kTopEarlgreyAlertPeripheralLcCtrl,
  [kTopEarlgreyAlertIdLcCtrlFatalBusIntegError] = kTopEarlgreyAlertPeripheralLcCtrl,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovAs] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovCg] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovGd] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovTsHi] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovTsLo] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovFla] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovOtp] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovOt0] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovOt1] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovOt2] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSensorCtrlAonRecovOt3] = kTopEarlgreyAlertPeripheralSensorCtrlAon,
  [kTopEarlgreyAlertIdSramCtrlRetAonFatalIntgError] = kTopEarlgreyAlertPeripheralSramCtrlRetAon,
  [kTopEarlgreyAlertIdSramCtrlRetAonFatalParityError] = kTopEarlgreyAlertPeripheralSramCtrlRetAon,
  [kTopEarlgreyAlertIdFlashCtrlRecovErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdFlashCtrlRecovMpErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdFlashCtrlRecovEccErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdFlashCtrlFatalIntgErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdAesRecovCtrlUpdateErr] = kTopEarlgreyAlertPeripheralAes,
  [kTopEarlgreyAlertIdAesFatalFault] = kTopEarlgreyAlertPeripheralAes,
  [kTopEarlgreyAlertIdHmacFatalFault] = kTopEarlgreyAlertPeripheralHmac,
  [kTopEarlgreyAlertIdKmacFatalFault] = kTopEarlgreyAlertPeripheralKmac,
  [kTopEarlgreyAlertIdKeymgrFatalFaultErr] = kTopEarlgreyAlertPeripheralKeymgr,
  [kTopEarlgreyAlertIdKeymgrRecovOperationErr] = kTopEarlgreyAlertPeripheralKeymgr,
  [kTopEarlgreyAlertIdCsrngFatalAlert] = kTopEarlgreyAlertPeripheralCsrng,
  [kTopEarlgreyAlertIdEntropySrcRecovAlert] = kTopEarlgreyAlertPeripheralEntropySrc,
  [kTopEarlgreyAlertIdEntropySrcFatalAlert] = kTopEarlgreyAlertPeripheralEntropySrc,
  [kTopEarlgreyAlertIdEdn0FatalAlert] = kTopEarlgreyAlertPeripheralEdn0,
  [kTopEarlgreyAlertIdEdn1FatalAlert] = kTopEarlgreyAlertPeripheralEdn1,
  [kTopEarlgreyAlertIdSramCtrlMainFatalIntgError] = kTopEarlgreyAlertPeripheralSramCtrlMain,
  [kTopEarlgreyAlertIdSramCtrlMainFatalParityError] = kTopEarlgreyAlertPeripheralSramCtrlMain,
  [kTopEarlgreyAlertIdOtbnFatal] = kTopEarlgreyAlertPeripheralOtbn,
  [kTopEarlgreyAlertIdOtbnRecov] = kTopEarlgreyAlertPeripheralOtbn,
  [kTopEarlgreyAlertIdRomCtrlFatal] = kTopEarlgreyAlertPeripheralRomCtrl,
};

