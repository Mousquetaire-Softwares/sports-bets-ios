//
//  CompetitionsLibrary.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

class CompetitionsLibrary : ObservableObject {
    typealias ModelRemoteApi = CompetitionModel.RemoteApi
    
    @Published private(set) var competitions : [CompetitionModel] = []
    @Published private(set) var apiState = ApiState.notInitialized
    
    func fetchCompetitions() async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: ModelRemoteApi.GetAll())
            competitions = try initCompetitions(from: data)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    private func initCompetitions(from data: Data) throws -> [CompetitionModel] {
        let remoteDTOs = try ModelRemoteApi.GetAll.decodeResponse(data)
        return remoteDTOs.map{ CompetitionModel(remoteData: $0) }
    }
    
}
