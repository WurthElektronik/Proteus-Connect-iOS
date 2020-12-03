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

// MARK: TerminalMessage

extension InfoBluetoothMessage: TerminalMessage {

    func getMessage(interpretation: DataInterpretationType) -> String {
        return message
    }

}

// MARK: TerminalMessageCellStyle

extension InfoBluetoothMessage: TerminalMessageCellStyle {

    var textAlignment: NSTextAlignment {
        get {
            return .left
        }
    }

    var leftMargin: CGFloat {
        get {
            return 20
        }
    }

    var rightMargin: CGFloat {
        get {
            return 40
        }
    }
}
