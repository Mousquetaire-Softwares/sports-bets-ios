//
//  CompetitionsLibrary.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

class CompetitionsLibrary : ObservableObject {
    @Published private(set) var competitions : [Competition] = []
    @Published private(set) var apiState = ApiState.none
    
    func fetchCompetitions() async {
        do {
            apiState = .fetching
            let data = try await WebApi.fetchData(for: BackendApi.Competition.getAll)
//            print("\(String(decoding: data, as: UTF8.self))")
            
            competitions = try initCompetitions(from: data)
            apiState = .loaded
        } catch {
            apiState = .failed(error.localizedDescription)
        }
    }
    
    
    private func initCompetitions(from data: Data) throws -> [Competition] {
        try JSONDecoder().decode([Competition].self, from: data)
    }
    
}
