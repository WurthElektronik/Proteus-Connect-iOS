// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import UIKit
import BluetoothSDK_iOS

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        UITableViewHeaderFooterView.appearance().tintColor = UIColor(named: "Surface")

        // setup UartConfig if using different config than default
        BluetoothManager.shared.applyConfiguration(config: AppUartConfig.self)

        // setup app settings
        AppSettings.setup()
        BleDevice.settingsDelegate = AppSettings.bleSettings

        // creating demo device
        DemoBluetoothDevice.createDemoDevice(device: DemoBluetoothDevice(asDummy: "Demo Device", UUID(uuidString: "00000000-5745-696c-6c75-6d696e617465")!))

        // activating Bluetooth
        BluetoothManager.shared.activateScanning()
        
        // put delay timer on the event loop to show the splash screen a bit longer
        RunLoop.current.run(until: Date(timeIntervalSinceNow: 1.0))
        
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
        // synchronize app configurations and disable ble scanning
        AppSettings.sync()
        // if background mode is not enabled connection will be closed.
        if !AppSettings.isBluetoothBackgroundModeEnabled {
            BluetoothManager.shared.disconnect()
            BluetoothManager.shared.deactivateScanning()
        }
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
        
        // enable ble scanning again
        BluetoothManager.shared.activateScanning()
    }

}
