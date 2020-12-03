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

@available(iOS 10.0, *)
extension AppSettings {
    
    /// Bluetooth settings field extension for AppSettings.
    public static let bleSettings : BleDeviceSettingsDelegate = AppBleSettings()
}


/// Bluetotoh app settings wrapper class.
@available(iOS 10.0, *)
private class AppBleSettings : BleDeviceSettingsDelegate {
    
    // MARK: Properties
    
    /// Retrives custom property values for the specified device.
    ///
    /// - Parameters:
    ///   - id: Device identifier.
    ///   - prop: Property key to retrive.
    /// - Returns: Value for the property value if any, else nil.
    func getDeviceProperty(for id: String, _ prop: String) -> Any? {
        if prop == BleDevice.kSettingsCustomNameKey {
            return AppSettings.getDeviceCustomName(id)
        }
        
        os_log_core("AppBleSettings.getDeviceProperty: invalid property %s", type: .error, prop)
        
        return nil
    }
    
    /// Stores a custom property value for the specified device.
    ///
    /// - Parameters:
    ///   - id: Device identifier.
    ///   - prop: Property key to store.
    ///   - value: New value to set.
    func setDeviceProperty(for id: String, _ prop: String, _ value: Any?) {
        if prop == BleDevice.kSettingsCustomNameKey {
            AppSettings.setDeviceCustomName(id, value as? String)
            return
        }
        
        os_log_core("AppBleSettings.setDeviceProperty: invalid property %s", type: .error, prop)
    }
}
