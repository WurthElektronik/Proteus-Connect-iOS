# Proteus Connect iOS (Archive)

July 2023 - Note: This SDK is now in status "archive" and will not be continued or maintained. Please refer to https://github.com/WurthElektronik/Proteus-Connect for the successor, which is a cross plattform project supporting Android and iOS as well as web-app.

The App will also switch over to the new project starting with version 1.4 of the app release.


-----------------
Archived
-----------------




# Proteus-Connect-iOS Starter Guide
Würth Elektronik eiSos GmbH & Co. KG

Contact: https://www.we-online.de/web/en/wuerth_elektronik/kontakte_weg/contacts_weg.php

Apple App store: https://apps.apple.com/de/app/proteus-connect/id1533941485

License Terms: Please refer to the pdf file "license_terms_Proteus-Connect_iOS_sdk.pdf" included in this repository.


## General information
This iOS app and sorucecodes are developed by Würth Elektronik eiSos is intended to show how to send ASCII or HEX payload to connected Proteus radio module using the Bluetooth Low Energy Standard. Additional features and updates will be released as they are developed.
Features
-	A library for iOS devices to communicate with Proteus Bluetooth modules.
-	Contains sample project to get started out of the box. 
-	Library can be used to scan, establish connection, transmitting and receiving data.
-	Sample project contains terminal to read and transmit data in hex and ascii.
-	Background mode can be enabled through settings.
-	Demo App can be downloaded form the App Store. 

## Requirements
-	iOS 12.0+
-	Xcode 12.0
-	Swift
-	Würth Elektronik Proteus Bluetooth Low Energy modules

## Installation
This Demo-App and Sourcecode is presented in two parts first a package for abstracting the Bluetooth Low Energy functionality for use in your own app, second a demo application "Proteus Connect" for iOS (also available in the Apple store) implementing a terminal stile tab for bi-directional communication with Proteus radio modules.
The github base repository is located at https://github.com/WE-eiSmart/Proteus-Connect-iOS. There you will find both parts, package for xcode as well as the demo app for xcode.
Add a Package Dependency
To add a package dependency to your Xcode project, select File > Swift Packages > Add Package Dependency and enter its repository URL. You can also navigate to your target’s General pane, and in the “Frameworks, Libraries, and Embedded Content” section, click the + button, select Add Other, and choose Add Package Dependency.

## Usage
Below you find some examples of how the framework can be used. Accompanied in the repository you find an example project that demonstrates a usage of the framework in practice. 

## Common
Make sure to import the BluetoothSDK framework in files that use it.
import BluetoothSDK_iOS

## Configuration
To enable bluetooth communication add following permissions to Info.plist
```swift
<key>NSBluetoothAlwaysUsageDescription</key>
<string>App uses bluetooth in order to communicate with the Proteus bluetooth modules.</string>
<key>NSBluetoothPeripheralUsageDescription</key>
<string>App uses bluetooth in order to communicate with the Proteus bluetooth modules.</string>
```

in AppDelegate add following methods:
```swift
func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
	// activating Bluetooth
	BluetoothManager.shared.activateScanning()
        
	return true
}
```

To use different bluetooth modules with different characteristics you have to implement a new UArtConfig or modify the existing AmberUartConfig.
```swift
public class YourConfig: UartConfig {
    /// Payload header type definition for user data.
    public static let kHeaderTypeUserData = 0x01

    // MARK: Base UUID
    // "6e400000-c352-11e5-953d-0002a5d5c51b"

    /// Associated service UUID as string.
    public static let kUartServiceUUID = "6e400001-c352-11e5-953d-0002a5d5c51b"

    /// Associated characteristics transmit UUID as string.
    public static let kUartServiceTransmitCharacteristicUUID = "6e400002-c352-11e5-953d-0002a5d5c51b"

    /// Associated characteristics receive UUID as string.
    public static let kUartServiceReceiveCharacteristicUUID = "6e400003-c352-11e5-953d-0002a5d5c51b"

	/// Minimum Received signal strength indicator (RSSI) value for discovery of bluetooth devices.
    ///
    /// Devices below minimum will not be discovered. No restrictions if minimum is nil.
    static var minimumRSSI: Int? { get }

    /// Maximum count for bad Received signal strength indicator (RSSI) measurement.
    ///
    /// If maximum is reached for a discovered bluetooth device, this device will be removed from discovery. Device will not be removed if value nil.
    static var maximumBadRSSICount: Int? { get }
}
```

To apply the configuration you have to call the BluetoothManager preferred on the app start (AppDelegate).
```swift
BluetoothManager.shared.applyConfiguration(config: YourConfig.self)
```

## Scan
If you activated scanning your iOS device will automatically scan for compatible bluetooth devices matching your configuration. All discovered bluetooth devices can be found in the BluetoothManager.
BluetoothManager.shared.devices

After the discovery of a bluetooth device following method will be called in the BluetoothManager BleDeviceManagerDelegate implementation.
```swift
public func deviceManager(_ manager: BleDeviceManager, didDiscoverDevice device: BleDevice){
    ...
}
```

##Connect
To connect to a discovered device:
BluetoothManager.shared.connect(toDevice: device);

After successful connection following method will be called in the BluetoothManager BleDeviceManagerDelegate implementation.
```swift
public func deviceManager(_ manager: BleDeviceManager, didConnectToDevice device: BleDevice) { 
	... 
}
```

You can access the connected device through:
BluetoothManager.shared.connectedDevice
```

if the connection could not be established following method will be called in the BluetoothManager BleDeviceManagerDelegate implementation.
public func deviceManager(_ manager: BleDeviceManager, didFailToConnectToDevice device: BleDevice) {
	...
}
```

## Disconnect
To disconnect from the current connected device:
```swift
BluetoothManager.shared.disconnect()
```

if the device disconnects following method will be called in the BluetoothManager BleDeviceManagerDelegate implementation.
```swift
public func deviceManager(_ manager: BleDeviceManager, didDisconnectFromDevice device: BleDevice){
	...
}
```

To listen for all connection and discovery calls use a BleConnectionListener implementation. Set this listener in the shared BluetoothManager instance. See demo project ScanViewController.
```swift
override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BluetoothManager.shared.listener = self
}

override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BluetoothManager.shared.listener = nil
}

extension YourViewController: BleConnectionListener {
	func didConnectToDevice(device: BleDevice) {
		...
    }

    func didFailToConnectToDevice(device: BleDevice) {
        ...
    }


    func didDisconnectFromDevice(device: BleDevice) {
        ...
    }

    func didDiscoverDevice(device: BleDevice) {
        ...
    }
}
```

## Transmit 
To transmit data use:
```swift
BluetoothManager.shared.sendData(data: yourData)
````
Currently 181 bytes + 1 header byte per package can be transmitted. This limitation to 182 bytes comes from within the Apple OS. For Hex and ASCII formatting look in TerminalViewController from demo project.

## Receive
When data form the connected device received, following method from the BluetoothManager for AmberBleServiceDelegate implementation will be called.
```swift
public func dataReceived(_ incomingData: Data) {
	let message = IncomingBluetoothMessage(timestamp: Date(), message: incomingData)
	appendMessage(message: message)
}
```

All bluetooth messages (incoming, outgoing, info) are stored:
```swift
BluetoothManager.shared.messages
```

To listen for all message calls use a BleMessageListener implementation. Set this listener in the shared BluetoothManager instance. See demo project TerminalViewController.
```swift
override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        BluetoothManager.shared.listener = self
}


override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        BluetoothManager.shared.listener = nil
}

extension YourViewController: BleMessageListener {
    func didReceiveMessage(message: BluetoothMessage) {
        
    }

    func didTransmitMessage(message: BluetoothMessage) {
        
    }
}
```

## Background Mode
To activate the background mode add following permissions to your Info.plist
```swift
<key>UIBackgroundModes</key>
<array>
<string>bluetooth-central</string>
</array>
```

## MTU
To read the MTU of the current connected device:
BluetoothManager.shared.connectedDevice.mtu
MTU cannot be modified from iOS side. It is currently restricted to a maximum of 182 Byte (iOS 14.2).

## RSSI
To get the RSSI value of the bluetooth device use the property rssi of the BleDevice object. The BleDeviceManager will handle all rssi updates while discovering devices. For a connected device the BluetoothManger will use a timer to retrieve the rssi value.
To listen for all rssi updates use a BleConnectionListener implementation. Set this listener in the shared BluetoothManager instance. See demo project ScanViewController.
```swift
extension YourViewController: BleConnectionListener {
	func didUpdateDevice(device: BleDevice) { 
		...
	}
}
```
If you want only to discover devices with a minimum rssi you can set it in the UartConfig.


## Known issues
V1.0.0
- currently no issues are known.
