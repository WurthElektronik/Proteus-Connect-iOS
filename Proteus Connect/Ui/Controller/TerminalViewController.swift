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

// MARK: Class implementation

class TerminalViewController: UIViewController {
    @IBOutlet weak var deviceNameLabel: UILabel!
    @IBOutlet weak var deviceIdLabel: UILabel!
    @IBOutlet weak var rssiLabel: UILabel!
    @IBOutlet weak var rssiImageView: UIImageView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var disconnectButton: UIButton!
    @IBOutlet weak var sendPayloadButton: UIButton!
    @IBOutlet weak var dataTypeSegmentControl: UISegmentedControl!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    weak var disconnectBarButton: UIBarButtonItem!

    /// Current message data interpretation. Default is hex.
    var currentMessageInterpretation: DataInterpretationType = .hex

    /// Contains all messages that are displayed in terminal.
    var messages: [BluetoothMessage] = []

    /// Bluetooth communication layer.
    var manager: BluetoothManagerProtocol {
        get {
            return BluetoothManager.shared
        }
    }

    @IBAction func onSendPayloadButtonTouch(_ sender: Any) {
        guard let data = getStringAsData(string: inputTextField.text ?? "") else {
            os_log_ui("TerminalViewController.onSendPayloadButtonTouch: invalid Data '%s'", type: .debug, inputTextField.text ?? "")
            return
        }
        manager.sendData(data: data)
    }

    @IBAction func onDisconnectButtonTouch(_ sender: Any) {
        manager.disconnect()
        inputTextField.resignFirstResponder()
    }
    
    @IBAction func onDataTypeSegmentControlValueChanged(_ sender: Any) {
        guard let newDataType = DataInterpretationType(rawValue: dataTypeSegmentControl.selectedSegmentIndex) else {
            os_log_ui("TerminalViewController.onDataTypeSegmentControlValueChanged: unknown DataType '%d'", type: .debug, dataTypeSegmentControl.selectedSegmentIndex)
            return
        }
        currentMessageInterpretation = newDataType
        resetInputTextField()
        messageTableView.reloadData()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.layoutSubviews()
        setupTableView()
        inputTextField.delegate = self
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        startObservingKeyboardEvents()
        manager.listener = self
        reloadView()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        stopObservingKeyboardEvents()
        manager.listener = nil
    }

    private func getStringAsData(string: String) -> Data? {
        switch currentMessageInterpretation {
        case .hex:
            return string.hexadecimal()
        case .ascii:
            return string.data(using: .ascii)
        }
    }

    private func getBytesCount(of strings: [String]) -> Double {
        let combinedString = String.combined(strings: strings, seperator: "")
        let charCount = Double(combinedString.count)
        switch currentMessageInterpretation {
        case .hex:
            return charCount / 2
        case .ascii:
            return charCount
        }
    }

    private func isInputTextValid() -> Bool {
        guard let inputText = inputTextField.text else {
            return false
        }

        switch currentMessageInterpretation {
        case .hex:
            return inputText.isValidHex()
        case .ascii:
            return !inputText.replacingOccurrences(of: " ", with: "").isEmpty
        }
    }

    private func reloadView() {
        reloadDeviceInformation()
        reloadRSSI()
        reloadMessages()
        reloadSendButton()
    }

    private func reloadSendButton() {
        sendPayloadButton.isEnabled = isInputTextValid() && manager.connectedDevice != nil
    }

}

// MARK: UITextFieldDelegate

extension TerminalViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard !isPayloadLengthValid(replacementString: string) else {
            return false
        }

        switch currentMessageInterpretation {
        case .hex:
            return String.hexadecimalCharacters.isSuperset(of: CharacterSet(charactersIn: string))
        default:
            return string.canBeConverted(to: .ascii)
        }
    }

    func isPayloadLengthValid(replacementString string: String) -> Bool {
        guard let maximumPayloadByteLength = manager.maximumPayloadByteLength, string.count > 0, getBytesCount(of: [inputTextField.text ?? "", string]) > Double(maximumPayloadByteLength) else {
            return false
        }
        return true
    }

    func textFieldDidChangeSelection(_ textField: UITextField) {
        reloadSendButton()
    }

    func resetInputTextField() {
        inputTextField.text = ""
        setPlaceholderText()
    }

    private func setPlaceholderText() {
        switch currentMessageInterpretation {
        case .hex:
            inputTextField.placeholder = "Payload (Hex)"
        case .ascii:
            inputTextField.placeholder = "Payload (Ascii)"
        }
    }
}

// MARK: UITableView

extension TerminalViewController: UITableViewDelegate, UITableViewDataSource {

    func setupTableView() {
        messageTableView.estimatedRowHeight = 40
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.register(UINib(nibName: TerminalMessageCell.identifier, bundle: nil), forCellReuseIdentifier: TerminalMessageCell.identifier)
        messageTableView.reloadData()
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TerminalMessageCell.identifier, for: indexPath) as! TerminalMessageCell
        if let message = messages[safe: indexPath.row] {
            cell.setContent(message: message, messageInterpretation: currentMessageInterpretation)
        }
        return cell
    }

}

// MARK: BleMessageListener

extension TerminalViewController: BleMessageListener {

    func didReceiveMessage(message: BluetoothMessage) {
        reloadMessages()
    }

    func didTransmitMessage(message: BluetoothMessage) {
        reloadMessages()
    }

    func reloadMessages() {
        self.messages = manager.messages
        DispatchQueue.main.async { [weak self] in
            self?.messageTableView.reloadData()
            if let rows = self?.messageTableView.numberOfRows(inSection: 0), rows > 0 {
                self?.messageTableView.scrollToRow(at: IndexPath(row: rows-1, section: 0), at: .bottom, animated: true)
            }
        }
    }
}

// MARK: BleConnectionListener

extension TerminalViewController: BleConnectionListener {

    func didConnectToDevice(device: BleDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadView()
        }
    }

    func didFailToConnectToDevice(device: BleDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadView()
        }
    }

    func didDisconnectFromDevice(device: BleDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.inputTextField.resignFirstResponder()
            self?.reloadView()
        }
    }

    func didDiscoverDevice(device: BleDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadView()
        }
    }

    func didUpdateDevice(device: BleDevice) {
        DispatchQueue.main.async { [weak self] in
            self?.reloadRSSI()
        }
    }

    func didLoseDevice(device: BleDevice) {
    }

    private func reloadDeviceInformation() {
        if let device = manager.connectedDevice {
            disconnectButton.isEnabled = true
            inputTextField.isEnabled = true
            deviceIdLabel.text = device.uuidShortString
            deviceNameLabel.text = device.name
            deviceNameLabel.textColor = UIColor(named: "SurfaceText")
        } else {
            disconnectButton.isEnabled = false
            inputTextField.isEnabled = false
            deviceIdLabel.text = ""
            deviceNameLabel.text = "No device connected!"
            deviceNameLabel.textColor = UIColor(named: "SurfaceTextInfo")
        }
    }

    private func reloadRSSI() {
        guard let rssi = manager.connectedDevice?.rssi else {
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

// MARK: KeyboardObserver

extension TerminalViewController: KeyboardObserver {

    func startObservingKeyboardEvents() {
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(onKeyboardHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func stopObservingKeyboardEvents() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    @objc func onKeyboardShow(notification: Notification) {
        guard let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue, let tabBarHeight = tabBarController?.tabBar.frame.height else {
            return
        }
        bottomConstraint.constant = -keyboardSize.height + tabBarHeight
        animateKeyboard()
    }

    @objc func onKeyboardHide(notification: Notification) {
        bottomConstraint.constant = 0
        animateKeyboard()
    }

    private func animateKeyboard() {
        UIView.animate(withDuration: 1, delay: 0, options: .curveEaseIn, animations: { self.view.layoutIfNeeded()
        })
    }

}
