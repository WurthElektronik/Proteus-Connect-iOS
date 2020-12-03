// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import CoreBluetooth
import BluetoothSDK_iOS

/// Bluetooth device class defines a virtuall demo device of the the wuerth multi color LED driver board.
open class DemoBluetoothDevice : AmberBleDevice {

    // MARK: Class implementation

    /// Holds internal virtuall identifier of the demo device. Set during instantiation.
    public private(set) var demoIdentifier : UUID

    /// Retrives the demo device identifier.
    open override var identifier : UUID {
        get {
            return isDemoDevice ? self.demoIdentifier : super.identifier;
        }
    }

    /// Holds internal virtuall name of the demo device. Set during instantiation.
    public private(set) var demoName : String

    /// Retrives the demo device name.
    public override var name : String {
        get {
            return isDemoDevice ? self.demoName : super.name;
        }
    }

    /// Holds internal virtuall connection state of the demo device.
    public private(set) var demoState: CBPeripheralState

    /// Retrives the demo device connection state.
    open override var state : CBPeripheralState {
        get {
            return isDemoDevice ? self.demoState : super.state;
        }
    }

    /// Internal update timer instance. Used to set random values during connection event.
    private var demoUpdateTimeoutTimer : Timer? = nil

    /// Creates an instance of a demo device.
    ///
    /// - Parameter name: Custom name of the demo device.
    /// - Parameter id: Custom identifier of the demo device.
    public init(asDummy name: String, _ id: UUID) {
        self.demoName = name
        self.demoIdentifier = id
        self.demoState = .disconnected
        super.init()
    }

    /// Adds a demo device to the current discovered devices queue. Useful for simulation purposes.
    ///
    /// - Parameter device: Demo device that will be added to discovered bluetooth queue.
    /// - Parameter manager: BleDeviceManager as default AmberBleDeviceManager is set.
    public static func createDemoDevice(device: DemoBluetoothDevice, manager: BleDeviceManager = AmberBleDeviceManager.shared) {
        manager.addDemoDevices([device])
    }

    /// Creates an instance wich is associateded with a peripheral interface.
    ///
    /// - Warning: Do not use this function. It always throws an exception.
    /// - Parameter peripheral: Not used.
    required public init(withPeripheral peripheral: CBPeripheral) {
        fatalError("init(withPeripheral:) not allowed for demo device")
    }

    // MARK: BleDeviceDelegate

    public override func didConnect() {
        self.demoState = .connected
    }

    public override func didDisconnect() {
        self.demoState = .disconnected
    }
}
