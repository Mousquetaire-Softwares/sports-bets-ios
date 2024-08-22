//
//  CompetitionsMenu.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import SwiftUI

struct CompetitionsMenuView: View {
    @ObservedObject var competitionsLibrary : CompetitionsLibrary
    
    var body: some View {
        if competitionsLibrary.apiState.isFetching && competitionsLibrary.competitions.isEmpty {
            ProgressView(label: { Text("fetching...")})
        } else {
            List {
                ForEach(competitionsLibrary.competitions) {
                    competition in
                    HStack {
                        Text("\(competition.code)")
                        Text("\(competition.description)")
                    }
                }
            }
            .refreshable {
                await competitionsLibrary.fetchCompetitions()
            }
        }
    }
}

#Preview {
    let lib = CompetitionsLibrary()
    Task { await lib.fetchCompetitions() }
    return CompetitionsMenuView(competitionsLibrary: lib)
}
