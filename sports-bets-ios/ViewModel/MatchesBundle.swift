//
//  MatchesBundle.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import Foundation

class MatchesBundle : ObservableObject {
    @Published var matches = [Match]()
    @Published private(set) var apiState = ApiState.none

    
    func fetchMatches(of competitionEdition: Int) async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: BackendApi.Match.getAll(ofCompetitionId: competitionEdition))
//            print("\(String(decoding: data, as: UTF8.self))")
            
            matches = try initMatches(from: data)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    private func initMatches(from data: Data) throws -> [Match] {
        print("\(String(decoding: data, as: UTF8.self))")
        let jsonDecoder = JSONDecoder()
        jsonDecoder.dateDecodingStrategy = .iso8601
        return try jsonDecoder.decode([Match].self, from: data)
    }
}
