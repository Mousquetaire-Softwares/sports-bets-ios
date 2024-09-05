//
//  UserParameters.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 03/09/2024.
//

import Foundation

class UserParameters : ObservableObject {
    var backendApiUrl : URL { BackendApi.baseUrl }
    @Published var fictiveBetsData = true
    @Published var allMatchesScoresAreNil = false
    
    
    func setBackendApiUrl(from urlString:String) throws {
        if urlString.isValidURL, let newUrl = URL(string: urlString) {
            BackendApi.baseUrl = newUrl
            objectWillChange.send()
        } else {
            throw URLError(.badURL)
        }
    }
}

extension UserParameters {
    struct DefaultValues {
        static let backendApiUrl = URL(string: "http://localhost:7700/api/v1")!
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
