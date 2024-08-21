//
//  MatchView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 21/08/2024.
//

import SwiftUI

struct MatchView: View {
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
                        Text("\(match.Nom_Dom)")
                        Image(systemName: "star.fill")
                        resultWithBet
                        Image(systemName: "star.fill")
                        Text("\(match.Nom_Ext)")
                    }
                    Spacer()
                }
            }
        }
    }
    
    @ViewBuilder
    private var header : some View {
        Text("Match n°\(match.Num), le \(match.DteHreDate!.formatted(date: .numeric, time: .shortened))")
        Text("\(match.Journee_Lib)")
        let Grp_Lib : String = {
            if let Grp_Cod = match.Grp_Cod {
                return "Groupe \(Grp_Cod), "
            } else {
                return .empty
            }
        }()
        Text("\(Grp_Lib)Stade \(match.Stade_Nom)")
            .font(.footnote)
            .italic()
    }
    
    @ViewBuilder
    private var resultWithBet : some View {
        Grid {
            GridRow {
                Text("\(match.Score_Dom)")
                    .modifier(Goals())
                    .font(.title)
                Text("\(match.Score_Ext)")
                    .modifier(Goals())
                    .font(.title)
            }
            
            GridRow {
                TextField("score", value: $match.Bet_Dom, formatter: NumberFormatter())
                    .modifier(Goals())
                
                TextField("", value: $match.Bet_Ext, formatter: NumberFormatter())
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
