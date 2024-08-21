//
//  CompetitionsMenu.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import SwiftUI

struct CompetitionsMenu: View {
    @ObservedObject var competitionsLibrary : CompetitionsLibrary
    
    var body: some View {
        if competitionsLibrary.apiState.isFetching && competitionsLibrary.competitions.isEmpty {
            ProgressView(label: { Text("fetching...")})
        } else {
            List(competitionsLibrary.competitions) {
                competition in
                HStack {
                    Text("\(competition.id)")
                    Text("\(competition.lib)")
                }
            }
            .refreshable {
                await competitionsLibrary.fetchCompetitions()
            }
        }
    }
}

#Preview {
    var lib = CompetitionsLibrary()
    Task { await lib.fetchCompetitions() }
    return CompetitionsMenu(competitionsLibrary: lib)
}
