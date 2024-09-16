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
    
    let userParameters : UserParameters
    
    init(with userParameters: UserParameters) {
        self.userParameters = userParameters
    }
    
    func setEmpty() {
        matches = []
        apiState = .loaded
    }
}


protocol RefreshableMatchesBundle {
    func fetchMatches(of competitionEditionId: CompetitionEditionModel.ID) async
}

extension MatchesBundle : RefreshableMatchesBundle where Match == RemoteMatchModel {
    typealias ModelRemoteApi = Match.RemoteApi
    
    @MainActor
    func fetchMatches(of competitionEditionId: CompetitionEditionModel.ID) async {
//        apiState = .fetching
        do {
            let response = try await ModelRemoteApi.GetAll(of: "\(competitionEditionId)").call()
            matches = try initMatches(from: response)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    internal func initMatches(from dtoList: [ModelRemoteApi.GetAll.DTO]) throws -> [Match] {
        return dtoList.map{
            var match = RemoteMatchModel(remoteData: $0)
            if userParameters.parametersModel.fictiveBetsData {
                match.fillScoresBetsWithRandomValues()
            }
            if userParameters.parametersModel.allMatchesScoresAreNil {
                match.localTeamScore = nil
                match.externalTeamScore = nil
            }
            return match
        }
    }
}
