//
//  MatchView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 21/08/2024.
//

import SwiftUI

struct MatchView<Match : MatchModel>: View {
    @Binding var match : Match
    
    var body: some View {
        matchResult(match)
            .background(Color.teal.opacity(0.2))
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.teal.opacity(0.2), lineWidth: 2)
            )
            
            .padding()
    }
    
    @ViewBuilder
    private func matchResult(_ match: Match) -> some View {
        VStack {
            
            HStack {
                VStack(alignment: .center)
                {
                    Spacer()
                    header
                    Spacer()
                    HStack(alignment: .center) {
                        Text("\(match.localTeamName)")
                        Image(systemName: "star.fill")
                        resultWithBet
                        Image(systemName: "star.fill")
                        Text("\(match.externalTeamName)")
                    }
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var header : some View {
        Text("Match.Title.Rank\(match.rankOrder).Date\(match.eventDate!.formatted(date: .numeric, time: .shortened))")
        Text("\(match.competitionPhaseDescription)")
        let competitionGroupLabel : String = {
            if let competitionGroup = match.competitionGroup {
                return "Groupe \(competitionGroup), "
            } else {
                return .empty
            }
        }()
        Text("\(competitionGroupLabel)Stade \(match.stadium)")
            .font(.footnote)
            .italic()
    }
    
    @ViewBuilder
    private var resultWithBet : some View {
        Grid {
            GridRow {
                Text(match.localTeamScore.unwrappedDescriptionOrEmpty)
                    .modifier(Goals())
                    .font(.title)
                Text(match.externalTeamScore.unwrappedDescriptionOrEmpty)
                    .modifier(Goals())
                    .font(.title)
            }
            
            GridRow {
                TextField("Match.Score".localized, value: $match.localTeamScoreBet, formatter: NumberFormatter())
                    .modifier(Goals())
                
                TextField("", value: $match.externalTeamScoreBet, formatter: NumberFormatter())
                    .modifier(Goals())
            }
        }
    }
}


struct Goals : ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(Color.gray.opacity(0.2))
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
            )
            
            .padding()
    }
    
}


//
//#Preview {
//    MatchView()
//}
