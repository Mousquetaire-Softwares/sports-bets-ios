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
    let userLogged : UserLogged
    
    init(with userParameters: UserParameters, for userLogged: UserLogged) {
        self.userParameters = userParameters
        self.userLogged = userLogged
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
    typealias MatchRemoteApi = Match.RemoteApi
    // FIXME: use a UserBetModel instead ?
    typealias UserBetRemoteApi = BackendApi.UserBet
    
    @MainActor
    func fetchMatches(of competitionEditionId: CompetitionEditionModel.ID) async {
//        apiState = .fetching
        do {
            let getAllResponse = try await MatchRemoteApi.GetAll(of: "\(competitionEditionId)").call()
            matches = try initMatches(from: getAllResponse)

            
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    internal func initMatches(from dtoList: [MatchRemoteApi.GetAll.DTO]) throws -> [Match] {
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
