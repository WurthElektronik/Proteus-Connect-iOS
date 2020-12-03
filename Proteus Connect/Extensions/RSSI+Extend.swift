// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import BluetoothSDK_iOS
import UIKit

extension RSSI {

    /// Gets a image for the corresponding signal strength.
    func getImage() -> UIImage? {
        var imageName = ""
        switch self {
        case .high:
            imageName = "icon.connection.3"
        case .medium:
            imageName = "icon.connection.2"
        case .low:
            imageName = "icon.connection.1"
        case .unusable:
            imageName = "icon.connection.0"
        }
        let image = UIImage(named: imageName)
        return image
    }

}
