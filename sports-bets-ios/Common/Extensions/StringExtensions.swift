//
//  StringExtensions.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation
import SwiftUI

extension String {
    static var empty = String("")
}

extension LocalizedStringKey {
    static var empty = LocalizedStringKey(.empty)
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
