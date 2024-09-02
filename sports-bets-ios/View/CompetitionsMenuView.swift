//
//  CompetitionsMenu.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import SwiftUI

struct CompetitionsMenuView: View {
    @EnvironmentObject var competitionsLibrary : CompetitionsLibrary
    
    var body: some View {
        ZStack {
            List {
                ForEach(competitionsLibrary.competitions) {
                    competition in
                    NavigationLink(value: competition.id) {
                        HStack {
                            Text("\(competition.code)")
                            Text("\(competition.description)")
                        }
                    }
                }
            }
            .navigationDestination(for: CompetitionModel.ID.self) {
                competitionId in
                let matchesBundle = MatchesBundle<RemoteMatchModel>()
                MatchesListView(matchesBundle: matchesBundle, competitionId: competitionId)
            }
            .refreshable {
                await competitionsLibrary.fetchCompetitions()
            }
            .onAppear {
                if competitionsLibrary.competitions.isEmpty {
                    Task { await competitionsLibrary.fetchCompetitions() }
                }
            }
            if competitionsLibrary.apiState.isFetching && competitionsLibrary.competitions.isEmpty {
                ProgressView(label: { Text("Generic.FetchingData".localized+"...")})
            }
            if let message = competitionsLibrary.apiState.failureMessage {
                Text(message)
            }
        }
    }
}

#Preview {
    let lib = CompetitionsLibrary()
//    Task { await lib.fetchCompetitions() }
    return CompetitionsMenuView()
        .environmentObject(lib)
}
