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
            .background(MatchViews.UIParameters.PrimaryColor.opacity(0.2))
            .background(.white)
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(MatchViews.UIParameters.PrimaryColor.opacity(0.2), lineWidth: 2)
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
                        VStack {
                            Image(systemName: "star.fill")
                            Text("\(match.localTeamName)")
                                .multilineTextAlignment(.center)
                        }
                        resultWithBet
                        VStack {
                            Image(systemName: "star.fill")
                            Text("\(match.externalTeamName)")
                                .multilineTextAlignment(.center)
                        }
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
            scoreResultGridRow
            scoreBetGridRow
        }
    }
    
    @ViewBuilder
    private var scoreResultGridRow : some View {
        if match.scoreIsSet {
            GridRow {
                Text(match.localTeamScore.unwrappedDescriptionOrEmpty)
                    .frame(maxWidth: .infinity)
                    .modifier(Goals())
                    .font(.title)
                
                Text("-")
                
                Text(match.externalTeamScore.unwrappedDescriptionOrEmpty)
                    .frame(maxWidth: .infinity)
                    .modifier(Goals())
                    .font(.title)
            }
        }
    }
    
    @ViewBuilder
    private var scoreBetGridRow : some View {
            GridRow {
                TextField(.empty, value: $match.localTeamScoreBet, format: .number)
                    .keyboardType(.decimalPad)
                    .modifier(Goals(userInput: match.scoreBetInputAllowed
                                    , inputValidated: match.localTeamScoreBet != nil))
                
                Text("-")
                
                TextField("", value: $match.externalTeamScoreBet, format: .number)
                    .keyboardType(.decimalPad)
                    .frame(maxHeight: .infinity)
                    .modifier(Goals(userInput: match.scoreBetInputAllowed
                                    , inputValidated: match.externalTeamScoreBet != nil))
            }
            .disabled(!match.scoreBetInputAllowed)
            .foregroundStyle(match.scoreBetInputAllowed ? .black : .gray)
    }
}

struct MatchViews {
    struct UIParameters {
        static let PrimaryColor : Color = Color(cgColor: #colorLiteral(red: 0.1428019085, green: 0.5530697601, blue: 0.2490302315, alpha: 1))
    }
}



struct Goals : ViewModifier {
    var userInput = false
    var inputValidated = false
    
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .aspectRatio(3, contentMode: .fit)
            .background(userInput ? Color.white : Color.gray.opacity(0.2))
            .background(.white)
            .cornerRadius(5)
            .overlay {
                if userInput {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(inputValidated ? Color.green.opacity(0.5) : Color.red.opacity(0.3), lineWidth: 2)
                } else {
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(Color.gray.opacity(0.2), lineWidth: 2)
                }
            }
    }
    
}


#Preview {
    struct PreviewContainer : View {
        @State private var matches = {
            let datas : [Data] = [
"""
{"Idt":265,"Num":3,"Hre":"21:00:00","Stade_Nom":"Stade olympique Lluís-Companys","Stade_Capacite":27,"Ville_Nom":"Barcelona","Fnt_cod":"ESP","Dte":"2023-09-19","DteHre":"2023-09-19T19:00:00.000Z","MatchTeam_Idt_Dom":188,"team_idt_Dom":30,"Nom_Dom":"FC Barcelone","Score_Dom":5,"MatchTeam_Idt_Ext":189,"team_idt_Ext":32,"Nom_Ext":"Royal Antwerp FC","Score_Ext":0,"Grp_Cod":"H","Journee_Lib":"1ère journée"}
""","""
{"Idt":264,"Num":2,"Hre":"18:45:00","Stade_Nom":"Stade du Wankdorf","Stade_Capacite":23,"Ville_Nom":"Berne","Fnt_cod":"SUI","Dte":"2023-09-19","DteHre":"2023-09-19T16:45:00.000Z","MatchTeam_Idt_Dom":186,"team_idt_Dom":25,"Nom_Dom":"BSC Young Boys","MatchTeam_Idt_Ext":187,"team_idt_Ext":27,"Nom_Ext":"RB Leipzig","Grp_Cod":"G","Journee_Lib":"1ère journée"}
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
