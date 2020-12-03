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

/// Cell used in Information View to enable or disable a setting.
class SettingsCell: UITableViewCell {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var settingSwitch: UISwitch!
    
    var switchAction: ((Bool) -> Void)?

    static var identifier: String {
        return "\(self)"
    }

    @IBAction func OnSwitchValueChanged(_ sender: Any) {
        switchAction?(settingSwitch.isOn)
    }

}
