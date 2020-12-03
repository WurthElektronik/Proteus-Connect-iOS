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

/// Cell used in scan view to display all scanned devices.
class BleDeviceCell: UITableViewCell {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var uuidLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var rssiImageView: UIImageView!

    static var identifier: String {
        return "\(self)"
    }

    func setContent(device: BleDevice) {
        nameLabel.text = device.customName
        uuidLabel.text = device.uuidShortString
        accessoryType = device.shouldReconnect ? .checkmark : .none
        tintColor = UIColor(named: device.isConnected ? "Primary" : "SurfaceTextInfo")
        displaySignalStrength(device: device)
    }

    private func displaySignalStrength(device: BleDevice) {
        guard let rssi = device.rssi else {
            rssiLabel.isHidden = true
            rssiImageView.isHidden = true
            return
        }
        rssiLabel.isHidden = false
        rssiImageView.isHidden = false
        rssiLabel.text = "\(rssi)dBm"
        rssiImageView.image = RSSI(rssi.intValue).getImage()
    }

}
