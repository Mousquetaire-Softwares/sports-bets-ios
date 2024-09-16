//
//  ParametersModel.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 15/09/2024.
//

import Foundation

struct ParametersModel : Codable {
    
    var fictiveBetsData = false
    var allMatchesScoresAreNil = false
    private(set) var backendApiUrl : URL
    
    init(backendApiUrl: URL) {
        self.backendApiUrl = backendApiUrl
    }
    
    
    init(from json:Data) throws {
        self = try JSONDecoder().decode(ParametersModel.self, from: json)
    }
    
    func json() throws -> Data {
        try JSONEncoder().encode(self)
    }
    
    mutating func setBackendApiUrl(from urlString:String) throws {
        if urlString.isValidURL, let newUrl = URL(string: urlString) {
            backendApiUrl = newUrl
        } else {
            throw URLError(.badURL)
        }
    }
}
