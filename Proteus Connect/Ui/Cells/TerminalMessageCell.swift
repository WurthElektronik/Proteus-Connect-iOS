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

/// Cell used in terminal to display all messages.
class TerminalMessageCell: UITableViewCell {
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var trailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var leadingConstraint: NSLayoutConstraint!
    
    static var identifier: String {
        return "\(self)"
    }

    func setContent(message: BluetoothMessage, messageInterpretation: DataInterpretationType = .hex) {
        dateLabel.text = message.timestamp.formatted()
        messageLabel.text = getInterpratedMessage(message: message, messageInterpretation: messageInterpretation)
        setStyle(message: message)
    }

    private func setStyle(message: BluetoothMessage) {
        let style = getStyle(message: message)
        dateLabel.textAlignment = style.textAlignment
        messageLabel.textAlignment = style.textAlignment
        leadingConstraint.constant = style.leftMargin
        trailingConstraint.constant = style.rightMargin
    }

    private func getStyle(message: BluetoothMessage) -> TerminalMessageCellStyle {
        guard let style = message as? TerminalMessageCellStyle else {
            return DefaultTerminalMessageStyle()
        }
        return style
    }

    private func getInterpratedMessage(message: BluetoothMessage, messageInterpretation: DataInterpretationType) -> String {
        guard let terminalMessage = message as? TerminalMessage else {
            os_log_ui("TerminalMessageCell.getInterpratedMessage: message not Terminal Message '%s'", type: .debug, "\(message.self)")
            return "Not identifiable message"
        }
        return terminalMessage.getMessage(interpretation: messageInterpretation)
    }
}
