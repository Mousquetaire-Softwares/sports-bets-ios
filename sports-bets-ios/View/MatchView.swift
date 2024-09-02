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
            .background(.white)
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.teal.opacity(0.2), lineWidth: 2)
            )
            .padding(30)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
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
            .lineLimit(1)
        Text("\(match.competitionPhaseDescription)")
            .lineLimit(1)
        let competitionGroupLabel : String = {
            if let competitionGroup = match.competitionGroup {
                return "Groupe \(competitionGroup), "
            } else {
                return .empty
            }
        }()
        Text("\(competitionGroupLabel)\(match.stadium)")
            .lineLimit(1)
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
                TextField("Match.Score", value: $match.localTeamScoreBet, formatter: NumberFormatter())
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


#Preview {
    struct PreviewContainer : View {
        @State private var matches = {
            let datas : [Data] = [
"""
{"Idt":265,"Num":3,"Hre":"21:00:00","Stade_Nom":"Stade olympique Lluís-Companys","Stade_Capacite":27,"Ville_Nom":"Barcelona","Fnt_cod":"ESP","Dte":"2023-09-19","DteHre":"2023-09-19T19:00:00.000Z","MatchTeam_Idt_Dom":188,"team_idt_Dom":30,"Nom_Dom":"FC Barcelone","Score_Dom":5,"MatchTeam_Idt_Ext":189,"team_idt_Ext":32,"Nom_Ext":"Royal Antwerp FC","Score_Ext":0,"Grp_Cod":"H","Journee_Lib":"1ère journée"}
""","""
{"Idt":264,"Num":2,"Hre":"18:45:00","Stade_Nom":"Stade du Wankdorf","Stade_Capacite":23,"Ville_Nom":"Berne","Fnt_cod":"SUI","Dte":"2023-09-19","DteHre":"2023-09-19T16:45:00.000Z","MatchTeam_Idt_Dom":186,"team_idt_Dom":25,"Nom_Dom":"BSC Young Boys","Score_Dom":1,"MatchTeam_Idt_Ext":187,"team_idt_Ext":27,"Nom_Ext":"RB Leipzig","Score_Ext":3,"Grp_Cod":"G","Journee_Lib":"1ère journée"}
"""
            ].map{ $0.data(using: .utf8)! }
            let dtos = datas.map{ try! JSONDecoder().decode(RemoteMatchModel.RemoteDTO.self, from: $0) }
            return dtos.map { RemoteMatchModel(remoteData: $0) }
        }()
        
         var body: some View {
             List(matches.indices, id:\.self) {
                 index in
                 MatchView<RemoteMatchModel>(match: $matches[index])
             }
             .padding(30)
         }
    }

    return PreviewContainer()
}
