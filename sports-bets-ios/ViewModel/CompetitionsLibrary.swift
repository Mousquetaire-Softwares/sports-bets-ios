//
//  CompetitionsLibrary.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

class CompetitionsLibrary : ObservableObject {
    typealias CompetitionRemoteApi = CompetitionModel.RemoteApi
    typealias CompetitionEditionRemoteApi = CompetitionEditionModel.RemoteApi
    
    @Published private(set) var competitions : [CompetitionModel] = []
    @Published private(set) var competitionsEditions : [CompetitionEditionModel] = []
    @Published private(set) var apiState = ApiState.notInitialized
    
    private let userLogged : UserLogged
    
    internal init(for userLogged: UserLogged) {
        self.userLogged = userLogged
    }
    
    @MainActor
    func fetchCompetitions() async {
        apiState = .fetching
        do {
            let competitionResponse = try await CompetitionRemoteApi.GetAll().call()
            competitions = try initCompetitions(from: competitionResponse)
            
            let competitionEditionResponse = try await CompetitionEditionRemoteApi.GetAll().call()
            competitionsEditions = try initCompetitionsEditions(from: competitionEditionResponse)
            
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
        
    }
    
    func getRemoteMatchBundle(with userParameters: UserParameters) -> MatchesBundle<RemoteMatchModel> {
        MatchesBundle<RemoteMatchModel>(with: userParameters, for: userLogged)
    }
    
    func firstCompetitionEditionId(of competitionId: CompetitionModel.ID) -> CompetitionEditionModel.ID? {
        if let competitionCode = competitions.first(where: { $0.id == competitionId })?.code
            , let competitionEditionId = competitionsEditions.first(where: { $0.competitionCode == competitionCode })?.id
        {
            return competitionEditionId
        } else {
            return nil
        }
    }
    
    private func initCompetitions(from dtoList: [CompetitionRemoteApi.GetAll.DTO]) throws -> [CompetitionModel] {
        return dtoList.map{ CompetitionModel(remoteData: $0) }
    }
    private func initCompetitionsEditions(from dtoList: [CompetitionEditionModel.RemoteDTO]) throws -> [CompetitionEditionModel] {
        return dtoList.map{ CompetitionEditionModel(remoteData: $0) }
    }
    
}
