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
        content(of:match)
            .padding()
            .background(MatchViews.UIParameters.PrimaryColor.opacity(0.2))
            .background(.white)
            .cornerRadius(20) /// make the background rounded
            .overlay( /// apply a rounded border
                RoundedRectangle(cornerRadius: 20)
                    .stroke(MatchViews.UIParameters.PrimaryColor.opacity(0.2), lineWidth: 2)
            )
            .padding(15)
            .shadow(radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/)
            .aspectRatio(1.4, contentMode: .fit)
    }
    
    @ViewBuilder
    private func content(of match: Match) -> some View {
        VStack {
            
            HStack {
                VStack(alignment: .center)
                {
                    header
                    Spacer()
                    HStack(alignment: .center) {
                        team(name: match.localTeamName, image: UIImage(systemName: "star.fill"))
                            .frame(maxWidth: .infinity)
                        
                        if match.scoreIsSet {
                            matchScoreAndBetResult
                                .frame(maxWidth: .infinity)
                        } else if match.scoreBetInputAllowed {
                            matchBetInput
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("-")
                        }
                        
                        team(name: match.externalTeamName, image: UIImage(systemName: "star.fill"))
                            .frame(maxWidth: .infinity)
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
    private func team(name: String, image: UIImage?) -> some View {
        VStack {
            if let image {
                Image(uiImage: image)
                    .padding(.bottom, 3)
            }
            Text(name)
                .multilineTextAlignment(.center)
                .lineSpacing(3)
        }
    }
    
    @ViewBuilder
    private var matchScoreAndBetResult : some View {
        Grid {
            matchScoreResultGridRow
            if match.userHasRegistered {
                matchBetResultGridRow
            }
        }
    }
    
    
    @ViewBuilder
    private var matchBetInput : some View {
        HStack {
            goalsBet($match.localTeamScoreBet)
            Text("-")
            goalsBet($match.externalTeamScoreBet)
        }
        .disabled(!match.scoreBetInputAllowed)
        .foregroundStyle(match.scoreBetInputAllowed ? .black : .gray)
        .font(.title)
    }
    
    @ViewBuilder
    private var matchScoreResultGridRow : some View {
        GridRow {
            goalsResult(match.localTeamScore)
            
            Text("-")
            
            goalsResult(match.externalTeamScore)
        }
        .font(.title)
    }
    
    @ViewBuilder
    private var matchBetResultGridRow : some View {
        GridRow {
            goalsResult(match.localTeamScoreBet)
                .padding(.leading, 10)
            Text("-")
            goalsResult(match.externalTeamScoreBet)
                .padding(.trailing, 10)
        }
        .foregroundColor(.gray)
//        .font(.caption)
    }
    
    @ViewBuilder
    private func goalsResult(_ value:Int?) -> some View {
        let presentedValue : String = {
            if let value {
                String("\(value)")
            } else {
                .empty
            }
        }()
        Text(presentedValue)
            .frame(maxWidth: .infinity)
//            .modifier(Goals())
//            .overlay {
//                RoundedRectangle(cornerRadius: 5)
//                    .stroke(Color.gray.opacity(0.2), lineWidth: 2)
//            }
    }
    
    
    @ViewBuilder
    private func goalsBet(_ value:Binding<Int?>) -> some View {
        TextField("", value: value, format: .number)
            .keyboardType(.decimalPad)
            .background((value.wrappedValue == nil ? Color.red : .green).opacity(Goals.UIParameters.BackgroundColorOpacity))
            .background(Color.white)
            .modifier(Goals())
            .overlay {
                RoundedRectangle(cornerRadius: 5)
                    .stroke((value.wrappedValue == nil ? Color.red : .green).opacity(Goals.UIParameters.BordersColorOpacity), lineWidth: 2)
            }
    }
    
    
}

struct MatchViews {
    struct UIParameters {
        static let PrimaryColor : Color = Color(cgColor: #colorLiteral(red: 0.1428019085, green: 0.5530697601, blue: 0.2490302315, alpha: 1))
        
    }
}



struct Goals : ViewModifier {
    func body(content: Content) -> some View {
        content
            .lineLimit(1)
            .multilineTextAlignment(.center)
            .cornerRadius(5)
            .aspectRatio(Goals.UIParameters.AspectRatio, contentMode: .fit)
    }
    
}

extension Goals {
    struct UIParameters {
        static let AspectRatio : CGFloat  = 0.9
        static let BackgroundColorOpacity : CGFloat = 0.05
        static let BordersColorOpacity : CGFloat = 0.5
        
    }
}


#Preview {
    struct PreviewContainer : View {
        @State private var matches = {
            let datas : [Data] = [
"""
{"Idt":265,"Num":4,"Hre":"21:00:00","Stade_Nom":"Stade olympique Lluís-Companys","Stade_Capacite":27,"Ville_Nom":"Barcelona","Fnt_cod":"ESP","Dte":"2023-09-19","DteHre":"2023-09-19T19:00:00.000Z","MatchTeam_Idt_Dom":188,"team_idt_Dom":30,"Nom_Dom":"FC Barcelone","Score_Dom":5,"MatchTeam_Idt_Ext":189,"team_idt_Ext":32,"Nom_Ext":"Royal Antwerp FC","Score_Ext":0,"Grp_Cod":"H","Journee_Lib":"1ère journée"}
""","""
{"Idt":264,"Num":2,"Hre":"18:45:00","Stade_Nom":"Stade du Wankdorf","Stade_Capacite":23,"Ville_Nom":"Berne","Fnt_cod":"SUI","Dte":"2023-09-19","DteHre":"2023-09-19T16:45:00.000Z","MatchTeam_Idt_Dom":186,"team_idt_Dom":25,"Nom_Dom":"BSC Young Boys","MatchTeam_Idt_Ext":187,"team_idt_Ext":27,"Nom_Ext":"RB Leipzig","Grp_Cod":"G","Journee_Lib":"1ère journée"}
"""
            ].map{ $0.data(using: .utf8)! }
            let dtos = datas.map{ try! JSONDecoder().decode(RemoteMatchModel.RemoteDTO.self, from: $0) }
            let matchesTemplates = dtos.map { RemoteMatchModel(remoteData: $0) }
            
            var matchesPreview = [RemoteMatchModel]()
            
            matchesPreview.append( {
                var match = matchesTemplates.first!
                match.userHasRegistered = false
                match.localTeamScoreBet = 9
                match.externalTeamScoreBet = 9
                return match
            }())
            matchesPreview.append( {
                var match = matchesTemplates.first!
                match.userHasRegistered = true
                match.localTeamScoreBet = 2
                match.externalTeamScoreBet = 0
                return match
            }())
            matchesPreview.append( {
                var match = matchesTemplates.first!
                match.userHasRegistered = true
                match.localTeamScoreBet = nil
                match.externalTeamScoreBet = nil
                return match
            }())
                        
            matchesPreview.append( {
                var match = matchesTemplates.last!
                match.userHasRegistered = false
                match.localTeamScoreBet = 9
                match.externalTeamScoreBet = 9
                return match
            }())
            matchesPreview.append( {
                var match = matchesTemplates.last!
                match.userHasRegistered = true
                match.localTeamScoreBet = 2
                match.externalTeamScoreBet = 0
                return match
            }())
            matchesPreview.append( {
                var match = matchesTemplates.last!
                match.userHasRegistered = true
                match.localTeamScoreBet = nil
                match.externalTeamScoreBet = nil
                return match
            }())
            
            return matchesPreview
        }()
        
         var body: some View {
             ScrollView {
                 ForEach(matches.indices, id:\.self) {
                     index in
                     MatchView<RemoteMatchModel>(match: $matches[index])
                 }
             }
         }
    }

    return PreviewContainer()
}
