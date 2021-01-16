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
    top_earlgrey_plic_interrupt_for_peripheral[122] = {
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
  [kTopEarlgreyPlicIrqIdFlashCtrlProgEmpty] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlProgLvl] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlRdFull] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlRdLvl] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdFlashCtrlOpDone] = kTopEarlgreyPlicPeripheralFlashCtrl,
  [kTopEarlgreyPlicIrqIdHmacHmacDone] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdHmacFifoEmpty] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdHmacHmacErr] = kTopEarlgreyPlicPeripheralHmac,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassa] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassb] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassc] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdAlertHandlerClassd] = kTopEarlgreyPlicPeripheralAlertHandler,
  [kTopEarlgreyPlicIrqIdNmiGenEsc0] = kTopEarlgreyPlicPeripheralNmiGen,
  [kTopEarlgreyPlicIrqIdNmiGenEsc1] = kTopEarlgreyPlicPeripheralNmiGen,
  [kTopEarlgreyPlicIrqIdNmiGenEsc2] = kTopEarlgreyPlicPeripheralNmiGen,
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
  [kTopEarlgreyPlicIrqIdPwrmgrWakeup] = kTopEarlgreyPlicPeripheralPwrmgr,
  [kTopEarlgreyPlicIrqIdOtbnDone] = kTopEarlgreyPlicPeripheralOtbn,
  [kTopEarlgreyPlicIrqIdKeymgrOpDone] = kTopEarlgreyPlicPeripheralKeymgr,
  [kTopEarlgreyPlicIrqIdKmacKmacDone] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdKmacFifoEmpty] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdKmacKmacErr] = kTopEarlgreyPlicPeripheralKmac,
  [kTopEarlgreyPlicIrqIdOtpCtrlOtpOperationDone] = kTopEarlgreyPlicPeripheralOtpCtrl,
  [kTopEarlgreyPlicIrqIdOtpCtrlOtpError] = kTopEarlgreyPlicPeripheralOtpCtrl,
  [kTopEarlgreyPlicIrqIdCsrngCsCmdReqDone] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsEntropyReq] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsHwInstExc] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdCsrngCsFifoErr] = kTopEarlgreyPlicPeripheralCsrng,
  [kTopEarlgreyPlicIrqIdEdn0EdnCmdReqDone] = kTopEarlgreyPlicPeripheralEdn0,
  [kTopEarlgreyPlicIrqIdEdn0EdnFifoErr] = kTopEarlgreyPlicPeripheralEdn0,
  [kTopEarlgreyPlicIrqIdEdn1EdnCmdReqDone] = kTopEarlgreyPlicPeripheralEdn1,
  [kTopEarlgreyPlicIrqIdEdn1EdnFifoErr] = kTopEarlgreyPlicPeripheralEdn1,
  [kTopEarlgreyPlicIrqIdEntropySrcEsEntropyValid] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEntropySrcEsHealthTestFailed] = kTopEarlgreyPlicPeripheralEntropySrc,
  [kTopEarlgreyPlicIrqIdEntropySrcEsFifoErr] = kTopEarlgreyPlicPeripheralEntropySrc,
};


/**
 * Alert Handler Alert Source to Peripheral Map
 *
 * This array is a mapping from `top_earlgrey_alert_id_t` to
 * `top_earlgrey_alert_peripheral_t`.
 */
const top_earlgrey_alert_peripheral_t
    top_earlgrey_alert_for_peripheral[23] = {
  [kTopEarlgreyAlertIdAesRecovCtrlUpdateErr] = kTopEarlgreyAlertPeripheralAes,
  [kTopEarlgreyAlertIdAesFatalFault] = kTopEarlgreyAlertPeripheralAes,
  [kTopEarlgreyAlertIdOtbnFatal] = kTopEarlgreyAlertPeripheralOtbn,
  [kTopEarlgreyAlertIdOtbnRecov] = kTopEarlgreyAlertPeripheralOtbn,
  [kTopEarlgreyAlertIdSensorCtrlAs] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlCg] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlGd] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlTsHi] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlTsLo] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlLs] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdSensorCtrlOt] = kTopEarlgreyAlertPeripheralSensorCtrl,
  [kTopEarlgreyAlertIdKeymgrFaultErr] = kTopEarlgreyAlertPeripheralKeymgr,
  [kTopEarlgreyAlertIdKeymgrOperationErr] = kTopEarlgreyAlertPeripheralKeymgr,
  [kTopEarlgreyAlertIdOtpCtrlFatalMacroError] = kTopEarlgreyAlertPeripheralOtpCtrl,
  [kTopEarlgreyAlertIdOtpCtrlFatalCheckError] = kTopEarlgreyAlertPeripheralOtpCtrl,
  [kTopEarlgreyAlertIdLcCtrlFatalProgError] = kTopEarlgreyAlertPeripheralLcCtrl,
  [kTopEarlgreyAlertIdLcCtrlFatalStateError] = kTopEarlgreyAlertPeripheralLcCtrl,
  [kTopEarlgreyAlertIdEntropySrcRecovAlertCountMet] = kTopEarlgreyAlertPeripheralEntropySrc,
  [kTopEarlgreyAlertIdSramCtrlMainFatalParityError] = kTopEarlgreyAlertPeripheralSramCtrlMain,
  [kTopEarlgreyAlertIdSramCtrlRetFatalParityError] = kTopEarlgreyAlertPeripheralSramCtrlRet,
  [kTopEarlgreyAlertIdFlashCtrlRecovErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdFlashCtrlRecovMpErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
  [kTopEarlgreyAlertIdFlashCtrlRecovEccErr] = kTopEarlgreyAlertPeripheralFlashCtrl,
};

