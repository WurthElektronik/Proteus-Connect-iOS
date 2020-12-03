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
class ScanViewController: UIViewController {
    
    // MARK: Class implementation
    
    @IBInspectable var renamePressDuration: TimeInterval = 1.0
    
    @IBInspectable var headerHeight: Float = 24.0
    
    @IBInspectable var devFound: String = ""
    @IBInspectable var devNotFound: String = ""
    
    @IBOutlet weak var tableViewDevices: UITableView!

    /// Bluetooth communication layer.
    public var manager: BluetoothManagerProtocol {
        get {
            return BluetoothManager.shared
        }
    }
    
    public override var tabBarController: MainTabBarController? {
        get {
            return super.tabBarController as! MainTabBarController?
        }
    }

    /// Cache for all discovered devices
    public var tableCache : [BleDevice] = []
    
    private var lastSelectionTime: Date = Date()

    /// Datetime when table was last refreshed.
    private var lastTableRefresh: Date?

    /// Constant for minimum time intervall to refresh table.
    private let minimumTimeIntervallForNextTableRefresh: Double = 1000

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        // Setting BleConnectionListener for connection listening.
        manager.listener = self
        reloadTableView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // Disabling connection listening when leaving screen.
        manager.listener = nil
    }
}

// MARK: BleConnectionListener

extension ScanViewController: BleConnectionListener {

    /// Will be called when connection to bluetooth device is successfull. Will automatically navigate to Terminal tab.
    func didConnectToDevice(device: BleDevice) {
        reloadTableView()
        if device.isConnected {
            tabBarController?.selectView(TerminalViewController.self)
        }
    }

    /// Will be called when connection to bluetooth device failed.
    func didFailToConnectToDevice(device: BleDevice) {
        os_log_ui("ScanViewController.didFailToConnectToDevice: failed to connect to %s", type: .debug, device.customName)
        reloadTableView()
    }

    /// Will be called when connection to bluetooth device failed.
    func didDisconnectFromDevice(device: BleDevice) {
        os_log_ui("ScanViewController.didDisconnectFromDevice: failed to connect to %s", type: .debug, device.customName)
        reloadTableView()
    }

    /// Will be called when a bluetooth device is discovered.
    func didDiscoverDevice(device: BleDevice) {
        reloadTableView()
    }

    /// Will be called when a bluetooth device is updated.
    func didUpdateDevice(device: BleDevice) {
        guard shouldRefresh() else {
            return
        }
        lastTableRefresh = Date()
        reloadTableView()
    }

    /// Will be called when a bluetooth device is lost.
    func didLoseDevice(device: BleDevice) {
        reloadTableView()
    }

    private func shouldRefresh() -> Bool {
        guard let date = lastTableRefresh else {
            return true
        }
        let passedTime = Date().timeIntervalSince(date) * 1000
        return passedTime > minimumTimeIntervallForNextTableRefresh
    }

}

// MARK: UITableView

extension ScanViewController: UITableViewDataSource, UITableViewDelegate {

    func setupTableView() {
        tableViewDevices.register(UINib(nibName: BleDeviceCell.identifier, bundle: nil), forCellReuseIdentifier: BleDeviceCell.identifier)
        tableViewDevices.reloadData()
    }

    func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.row == 0 {
            return nil;
        }
        return indexPath
    }

    func tableViewSyncCache() {
        self.tableCache.removeAll()

        for (_, device) in self.manager.devices.enumerated() {
            self.tableCache.append(device)
        }
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tableCache.count + 1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if indexPath.row == 0 {
            let tableViewCellHeader = self.tableViewDevices.dequeueReusableCell(withIdentifier: "DeviceHeaderCell", for: indexPath)
            tableViewCellHeader.textLabel?.text = (self.tableCache.count > 0) ? self.devFound : self.devNotFound

            return tableViewCellHeader
        }
        else
        if let device = self.tableCache[safe: indexPath.row - 1] {
            let cell = tableView.dequeueReusableCell(withIdentifier: BleDeviceCell.identifier, for: indexPath) as! BleDeviceCell
            cell.setContent(device: device)

            // only attach gesture recognizer if there is no one already attached
            if cell.gestureRecognizers?.isEmpty ?? true {

                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didRecognizeTapGesture))
                tapGestureRecognizer.cancelsTouchesInView = true
                tapGestureRecognizer.numberOfTapsRequired = 1
                tapGestureRecognizer.delegate = self
                cell.addGestureRecognizer(tapGestureRecognizer)
                cell.isUserInteractionEnabled = true
            }
            return cell
        }

        return UITableViewCell()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(self.headerHeight)
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.isUserInteractionEnabled = false
        headerView.backgroundColor = UIColor.clear
        return headerView
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerView = UIView()
        footerView.isUserInteractionEnabled = false
        footerView.backgroundColor = UIColor.clear
        return footerView
    }

    func reloadTableView() {
        tableViewSyncCache()
        DispatchQueue.main.async { [weak self] in
            self?.tableViewDevices.reloadData()
        }
    }

}

// MARK: UIGestureRecognizerDelegate

extension ScanViewController: UIGestureRecognizerDelegate {

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    @objc public func didRecognizeTapGesture(_ recognizer: UITapGestureRecognizer) {
        guard recognizer.state == .ended else {
            return
        }

        guard let indexPath = self.tableViewDevices.indexPath(for: recognizer.view as! UITableViewCell) else {
            return
        }

        guard let device = self.tableCache[safe: indexPath.row - 1] else {
            return
        }

        guard Date().timeIntervalSince(self.lastSelectionTime) > 1.0  else {
            return
        }

        self.lastSelectionTime = Date()

        os_log_ui("ScanViewController.didRecognizeTapGesture: %s", type: .info, device.customName)

        if device.isConnected {
            tabBarController?.selectView(TerminalViewController.self)
        }
        else {
            self.manager.connect(toDevice: device)
            self.tableViewDevices.reloadRows(at: [indexPath], with: .fade)
        }
    }

}
