//
//  UserParameters.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 03/09/2024.
//

import Foundation

class UserParameters : ObservableObject {
    @Published private(set) var backendApiUrl = URL(string: "http://localhost:7700/api/v1")!
    @Published var fictiveBetsData = true
    
    func setBackendApiUrl(from urlString:String) throws {
        if urlString.isValidURL, let newUrl = URL(string: urlString) {
            backendApiUrl = newUrl
        } else {
            throw URLError(.badURL)
        }
    }
}


extension String {
    var isValidURL: Bool {
        if let url = URL(string: self), url.scheme == "http" || url.scheme == "https" {
            return true
        } else {
            return false
        }
    }
}
