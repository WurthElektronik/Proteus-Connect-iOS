// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import UIKit
import os.log
import BluetoothSDK_iOS

@IBDesignable
class MainNavigationController: UINavigationController {

    // MARK: Class implementation
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if !AppSettings.isPrivacyPolicyAccepted {
            os_log_ui("MainNavigationController.viewDidLoad: performSegue('seguePrivacyInstant') because AppSettings.isPrivacyPolicyAccepted equals to false", type: .info)
            DispatchQueue.main.async(execute: {
                self.performSegue(withIdentifier: "seguePrivacyInstant", sender: self)
            })
        }
    }

}

