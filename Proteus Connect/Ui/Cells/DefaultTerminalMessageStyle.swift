// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import UIKit

/// The default cell style if message has no defined style.
struct DefaultTerminalMessageStyle: TerminalMessageCellStyle {
    var textAlignment: NSTextAlignment = .left
    var leftMargin: CGFloat = 20
    var rightMargin: CGFloat = 40
}
