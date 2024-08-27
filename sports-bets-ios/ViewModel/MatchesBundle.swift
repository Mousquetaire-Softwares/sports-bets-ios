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


protocol RefreshableMatchesBundle {
    func fetchMatches(of competitionEdition: Int) async
}

extension MatchesBundle : RefreshableMatchesBundle where Match == RemoteMatchModel {
    typealias ModelRemoteApi = Match.RemoteApi
    
    @MainActor
    func fetchMatches(of competitionEdition: Int) async {
//        apiState = .fetching
        do {
            let response = try await ModelRemoteApi.GetAll(competitionId: competitionEdition).call()
            matches = try initMatches(from: response)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    internal func initMatches(from dtoList: [ModelRemoteApi.GetAll.DTO]) throws -> [Match] {
        return dtoList.map{ RemoteMatchModel(remoteData: $0) }
    }
}
