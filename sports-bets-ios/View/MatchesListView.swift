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
        ScrollView {
            if let message = matchesBundle.apiState.failureMessage {
                Text(message)
            }
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
    Task { await bundle.fetchMatches(of:3) }
    return MatchesListView(matchesBundle: bundle)
}
