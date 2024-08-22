//
//  MatchesBundle.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import Foundation

class MatchesBundle<Match : MatchModel> : ObservableObject {
    @Published var matches = [Match]()
    @Published private(set) var apiState = ApiState.none
}

extension MatchesBundle where Match == RemoteMatchModel {
    
    func fetchMatches(of competitionEdition: Int) async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: Match.RemoteApi.getAll(ofCompetitionId: competitionEdition))
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
        let matchesModel = try jsonDecoder.decode([Match.RemoteData].self, from: data)
        
        return matchesModel.map{ RemoteMatchModel(matchModel: $0) }
    }
}
