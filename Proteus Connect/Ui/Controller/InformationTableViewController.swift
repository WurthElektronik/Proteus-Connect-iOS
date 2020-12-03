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
class InformationTableViewController: UITableViewController {
    
    // MARK: Class implementation
    
    @IBInspectable var contactUri: String = ""
    @IBInspectable var imprintUri: String = ""
    
    @IBInspectable var headerHeight: Float = 24.0
    
    @IBOutlet weak var tableViewCellPrivacyPolicy: UITableViewCell!
    @IBOutlet weak var bluetoothBackgroundSettingCell: SettingsCell!
    @IBOutlet weak var tableViewCellContact: UITableViewCell!
    @IBOutlet weak var tableViewCellImprint: UITableViewCell!
    @IBOutlet weak var labelVersionValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupInfoCells()
        setupSettingCells()
    }

    private func setupInfoCells() {
        if let textVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            if textVersion.hasPrefix("0.") {
                self.labelVersionValue?.text = textVersion + " beta"
            }
            else {
                self.labelVersionValue?.text = textVersion
            }
        }
    }

    private func setupSettingCells() {
        bluetoothBackgroundSettingCell.settingSwitch.isOn = AppSettings.isBluetoothBackgroundModeEnabled
        bluetoothBackgroundSettingCell.switchAction = { value in
            AppSettings.isBluetoothBackgroundModeEnabled = value
        }
    }

    // MARK: UITableViewDelegate
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(self.headerHeight)
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return super.tableView(tableView, heightForFooterInSection: section)
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.isUserInteractionEnabled = false
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.isUserInteractionEnabled = false
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let cell = tableView.cellForRow(at: indexPath)
        if cell == tableViewCellPrivacyPolicy {
            onSelectedPrivacyCell()
        } else if cell == tableViewCellContact {
            onSelectedContactCell()
        } else if cell == tableViewCellImprint {
            onSelectedImprintCell()
        } else {
            os_log_ui("InformationTableViewController.didSelectRowAt: no action definded for selected cell", type: .debug)
        }
    }

    private func onSelectedPrivacyCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.htmlTitle = "Privacy"
        vc.url = "PrivacyPolicy_EN"
        navigationController?.show(vc, sender: nil)
    }

    private func onSelectedContactCell() {
        if let url = URL(string: self.contactUri) {
            UIApplication.shared.open(url)
        }
    }

    private func onSelectedImprintCell() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: "InfoViewController") as! InfoViewController
        vc.htmlTitle = "Imprint"
        vc.url = "Imprint_EN"
        navigationController?.show(vc, sender: nil)
    }
}
