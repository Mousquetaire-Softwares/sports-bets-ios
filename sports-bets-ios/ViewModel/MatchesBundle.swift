//
//  MatchesBundle.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import Foundation

class MatchesBundle<Match : MatchModel> : ObservableObject {
    @Published var matches = [Match]()
    @Published private(set) var apiState = ApiState.notInitialized
}

extension MatchesBundle where Match == RemoteMatchModel {
    typealias ModelRemoteApi = Match.RemoteApi
    
    func fetchMatches(of competitionEdition: Int) async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: ModelRemoteApi.GetAll(competitionId: competitionEdition))
//            print("\(String(decoding: data, as: UTF8.self))")
            
            matches = try initMatches(from: data)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    internal func initMatches(from data: Data) throws -> [Match] {
        let remoteDTOs = try ModelRemoteApi.GetAll.decodeResponse(data)
        return remoteDTOs.map{ RemoteMatchModel(remoteData: $0) }
    }
}
