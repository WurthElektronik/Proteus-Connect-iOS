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

extension IncomingBluetoothMessage: TerminalMessage {

    func getMessage(interpretation: DataInterpretationType) -> String {
        switch interpretation {
        case .hex:
            return message.hexDescription()
        default:
            return String(data: message, encoding: .ascii) ?? ""
        }
    }

}

// MARK: TerminalMessageCellStyle

extension IncomingBluetoothMessage: TerminalMessageCellStyle {
    
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
