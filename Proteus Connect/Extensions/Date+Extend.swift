// __          ________        _  _____
// \ \        / /  ____|      (_)/ ____|
//  \ \  /\  / /| |__      ___ _| (___   ___  ___
//   \ \/  \/ / |  __|    / _ \ |\___ \ / _ \/ __|
//    \  /\  /  | |____  |  __/ |____) | (_) \__ \
//     \/  \/   |______|  \___|_|_____/ \___/|___/
//
// Copyright © 2020 Würth Elektronik GmbH & Co. KG.

import Foundation

extension Date {

    static let dateFormatter = DateFormatter()

    static let defaultDateFormat = "HH:mm:ss.SSS"

    func formatted(dateFormat: String = Date.defaultDateFormat) -> String {
        Date.dateFormatter.dateFormat = dateFormat
        let value = Date.dateFormatter.string(from: self)
        return value
    }

}
