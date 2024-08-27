//
//  OptionalExtension.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 23/08/2024.
//

import Foundation

extension Optional where Wrapped : CustomStringConvertible {
    var unwrappedDescriptionOrEmpty : String {
        switch(self) {
        case .none:
            return .empty
        case .some(let value):
            return value.description
        }
    }
}
