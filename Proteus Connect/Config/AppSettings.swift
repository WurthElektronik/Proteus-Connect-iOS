// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import Foundation
import os.log


/// Static AppSettings class is used to store and retrive app specific configurations.
public class AppSettings {
    
    // MARK: Properties

    /// Key value for device custom name list.
    public static let deviceCustomNameListKey: String = "deviceCustomNameList";
    
    /// List of custom device names
    private static var deviceCustomNameList : Dictionary<String, String>? = nil
    
    /// Retrives stored custom name for specified device identifier.
    ///
    /// - Parameter deviceId: Device identifier.
    /// - Returns: Custom name for the specified device if any, else nil.
    public static func getDeviceCustomName(_ deviceId: String) -> String? {
        return deviceCustomNameList![deviceId]
    }
    
    /// Sets or overrides custom device name for specified device identifier.
    ///
    /// - Parameters:
    ///   - deviceId: Device identifier.
    ///   - name: New custom device name.
    public static func setDeviceCustomName(_ deviceId: String, _ name: String?) {
        if name?.isEmpty ?? true {
            deviceCustomNameList!.removeValue(forKey: deviceId)
        }
        else {
           deviceCustomNameList![deviceId] = name
        }
    }
    
    
    /// Key value for privacy policy accepted.
    public static let privacyPolicyAcceptedKey: String = "privacyPolicyAccepted";
    
    /// Retrives or stores the state of privacy policy acception.
    public static var isPrivacyPolicyAccepted: Bool {
        get {
            return data.bool(forKey: privacyPolicyAcceptedKey)
        }
        set(accepted) {
            if (accepted != isPrivacyPolicyAccepted) {
                data.set(accepted, forKey: privacyPolicyAcceptedKey)
                data.synchronize()
            }
        }
    }

    /// Key value for enabled Bluetooth background mode.
    public static let bluetoothBackgroundModeEnabledKey: String = "bluetoothBackgroundModeEnabledKey";

    /// Retrives or stores the state of bluetooth background mode. Only while enabled App will communicate and reconnect with Bluetooth Device in background mode.
    /// - Important:
    ///  Ensure that you also enabled background mode in your Info.plist. Otherwise no communication in background will be possible:
    /// \<key>UIBackgroundModes\</key>
    /// \<array>
    ///    \<string>bluetooth-central\</string>
    /// \</array>
    public static var isBluetoothBackgroundModeEnabled: Bool {
        get {
            return data.bool(forKey: bluetoothBackgroundModeEnabledKey)
        }
        set(accepted) {
            if (accepted != isBluetoothBackgroundModeEnabled) {
                data.set(accepted, forKey: bluetoothBackgroundModeEnabledKey)
                data.synchronize()
            }
        }
    }
    
    // MARK: Generic
    
    /// Default storage instance.
    private static var data: UserDefaults {
        get {
            return UserDefaults.standard
        }
    }
    
    /// This class can not be instantiated, because it contains only static methods.
    private init() {}
    
    /// Prepares the AppSettings for usage.
    public static func setup() {
        deviceCustomNameList = (data.dictionary(forKey: deviceCustomNameListKey) as? Dictionary<String, String>?) ?? nil
        if deviceCustomNameList == nil {
            deviceCustomNameList = Dictionary<String, String>()
        }
    }
    
    /// Stores outstanding app specific configurations to the system.
    public static func sync() {
        data.set(deviceCustomNameList, forKey: deviceCustomNameListKey)
        data.synchronize()
    }
}
