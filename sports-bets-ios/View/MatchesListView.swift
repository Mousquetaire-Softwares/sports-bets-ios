//
//  MatchesList.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 20/08/2024.
//

import SwiftUI

struct MatchesListView<Match : MatchModel>: View {
    @ObservedObject var matchesBundle : MatchesBundle<Match>
    
    var body: some View {
        ZStack {
            if !matchesBundle.matches.isEmpty {
                matchesScrollableList
            } else {
                if matchesBundle.apiState.isFetching && matchesBundle.matches.isEmpty {
                    ProgressView(label: { Text("fetching...")})
                } else if let message = matchesBundle.apiState.failureMessage {
                    Text(message)
                } else if case .loaded = matchesBundle.apiState, matchesBundle.matches.isEmpty {
                    VStack {
                        Text("No matches are scheduled here")
                        Image("background-matchesListEmpty-1")
                            .resizable()
                            .scaledToFit()
                            .ignoresSafeArea()
//                            .transition(.opacity)
                            .animation(.easeInOut(duration: 3), value: matchesBundle.apiState)
                    }
                        
                        
                }
            }
            
            if let message = matchesBundle.apiState.failureMessage {
                Text(message)
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
            Task{
                //                await matchesBundle.fetchMatches(of: 3)
            }
        }
    }
    
}

#Preview {
    let bundle = MatchesBundle<RemoteMatchModel>()
    Task { await bundle.fetchMatches(of:2) }
    return MatchesListView(matchesBundle: bundle)
}
