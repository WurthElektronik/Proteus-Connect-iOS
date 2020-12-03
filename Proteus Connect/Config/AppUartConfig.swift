// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import Foundation
import BluetoothSDK_iOS

/// AppUartConfig defines the uart configuration of the Proteus Connect bluetooth device protocol.
class AppUartConfig: UartConfig {
    
    /// Payload header type definition for user data.
    public static let kHeaderTypeUserData = 0x01

    /// Associated service UUID as string.
    public static let kUartServiceUUID = "6e400001-c352-11e5-953d-0002a5d5c51b"

    /// Associated characteristics transmit UUID as string.
    public static let kUartServiceTransmitCharacteristicUUID = "6e400002-c352-11e5-953d-0002a5d5c51b"

    /// Associated characteristics receive UUID as string.
    public static let kUartServiceReceiveCharacteristicUUID = "6e400003-c352-11e5-953d-0002a5d5c51b"

    /// Minimum Received signal strength indicator (RSSI) value for discovery of bluetooth devices.
    ///
    /// Devices below minimum will not be discovered. No restrictions if minimum is nil.
    public static var minimumRSSI: Int? = -65

    /// Maximum count for bad Received signal strength indicator (RSSI) measurement.
    ///
    /// If maximum is reached for a discovered bluetooth device, this device will be removed from discovery. Device will not be removed if value nil.
    public static var maximumBadRSSICount: Int? = 360
}
