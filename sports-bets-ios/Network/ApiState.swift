//
//  ApiState.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import Foundation

enum ApiState {
    case none
    case loaded
    case fetching
    case failed(String)
    
    var isFetching : Bool {
        switch(self) {
        case .fetching: return true
        default: return false
        }
    }    
    var failureMessage : String? {
        switch(self) {
        case .failed(let message): return message
        default: return nil
        }
    }
}
