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
class MainTabBarController: UITabBarController  {
    
    // MARK: Class implementation
    @IBInspectable var defaultPageIndex: Int = 0
    
    private var hasBeenShown = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // select default page
        if !self.hasBeenShown {
            self.selectedIndex = self.defaultPageIndex
            self.hasBeenShown = true
        }
    }
    
    public func selectView(_ targetType: UIViewController.Type) {
        guard let viewControllers = self.viewControllers else {
            os_log_ui("MainTabBarController.selectView: viewControllers list is nil", type: .error)
            return
        }
        
        for (index, viewController) in viewControllers.enumerated() {
            if type(of: viewController) == targetType {
                self.selectedIndex = index
                return
            }
        }
        
        os_log_ui("MainTabBarController.selectView: viewController of type %s not found", type: .error, targetType.description())
    }
}
