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
    
    @MainActor 
    func fetchCompetitions() async {
        apiState = .fetching
        do {
            let response = try await ModelRemoteApi.GetAll().call()
            competitions = try initCompetitions(from: response)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
        
    }
    
    
    private func initCompetitions(from dtoList: [ModelRemoteApi.GetAll.DTO]) throws -> [CompetitionModel] {
        return dtoList.map{ CompetitionModel(remoteData: $0) }
    }
    
}
