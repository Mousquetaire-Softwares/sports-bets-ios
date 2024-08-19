//
//  Item.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
