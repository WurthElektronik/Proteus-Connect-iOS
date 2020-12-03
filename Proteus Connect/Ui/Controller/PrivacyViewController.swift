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
class PrivacyViewController: UIViewController {
    
    // MARK: Class implementation
    
    @IBOutlet weak var acceptButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.hidesBackButton = !AppSettings.isPrivacyPolicyAccepted
        acceptButton.isHidden = AppSettings.isPrivacyPolicyAccepted
    }
    
    @IBAction func onAcceptButtonTouchUpInside(_ sender: Any) {
        os_log_ui("PrivacyViewController.onAcceptButtonTouchUpInside: set AppSettings.isPrivacyPolicyAccepted to true", type: .info)
        
        AppSettings.isPrivacyPolicyAccepted = true
        navigationController?.popViewController(animated: true)
    }
    
}
