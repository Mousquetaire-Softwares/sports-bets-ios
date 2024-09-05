//
//  MatchesList.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import SwiftUI

struct MatchesListView<Match : MatchModel>: View {
    @ObservedObject var matchesBundle : MatchesBundle<Match>
    @State var competitionId : Int
    
    var body: some View {
        ZStack {
            matchesScrollableList
            
            matchesFetchingApiStatus

        }
    }
    
    @ViewBuilder
    var matchesFetchingApiStatus : some View {
        if matchesBundle.apiState.isLoading && matchesBundle.matches.isEmpty {
            ProgressView(label: { Text("Generic.FetchingData")})
        } else if let message = matchesBundle.apiState.failureMessage {
            Text(message)
        } else if case .loaded = matchesBundle.apiState, matchesBundle.matches.isEmpty {
            VStack {
                Text("MatchesList.NoMatch")
                Image("background-matchesListEmpty-1")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                    .animation(.easeInOut(duration: 3), value: matchesBundle.apiState)
            }
        }
    }
    
    @ViewBuilder
    var matchesScrollableList : some View {
        ScrollView {
            
            ForEach( matchesBundle.matches.indices, id: \.self) {
                matchIndex in
                Spacer()
                MatchView(match: $matchesBundle.matches[matchIndex])
                Spacer()
            }
            
        }
        .refreshable {
            await fetchMatches()
        }
        .onAppear {
            if matchesBundle.matches.isEmpty {
                Task{ await fetchMatches() }
            }
        }
    }
    
    private func fetchMatches() async {
        // FIXME: Probably not the right way to do it ...
        if let matchesBundle = matchesBundle as? RefreshableMatchesBundle {
            await matchesBundle.fetchMatches(of: competitionId)
        }
    }
}

#Preview {
    let userParameters = UserParameters()
    let bundle = MatchesBundle<RemoteMatchModel>(userParameters: userParameters)
    return MatchesListView(matchesBundle: bundle, competitionId: 2)
}
