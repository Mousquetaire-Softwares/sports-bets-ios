//
//  CompetitionsLibrary.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

class CompetitionsLibrary : ObservableObject {
    @Published private(set) var competitions : [CompetitionModel] = []
    @Published private(set) var apiState = ApiState.none
    
    func fetchCompetitions() async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: CompetitionModel.RemoteApi.getAll)
            competitions = try initCompetitions(from: data)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    private func initCompetitions(from data: Data) throws -> [CompetitionModel] {
        let competitionsRemoteData = try JSONDecoder().decode([CompetitionModel.RemoteData].self, from: data)
        return competitionsRemoteData.map{ CompetitionModel(remoteData: $0) }
    }
    
}
