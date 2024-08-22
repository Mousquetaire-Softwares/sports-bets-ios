//
//  MatchModel.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 21/08/2024.
//

import Foundation

protocol MatchModel : Identifiable {
    var id : Int { get }
    var rankOrder : Int { get }
    var stadium : String { get }
    var city : String { get }
    var localTeamId : Int { get }
    var localTeamName : String { get }
    var localTeamScore : Int { get }
    var externalTeamId : Int { get }
    var externalTeamName : String { get }
    var externalTeamScore : Int { get }
    var competitionGroup : String? { get }
    var competitionPhaseDescription : String { get }
    var localTeamScoreBet : Int? { get set }
    var externalTeamScoreBet : Int? { get set }
    var eventDate: Date? { get }
}

struct RemoteMatchModel : MatchModel {
    typealias RemoteData = BackendData.Match
    typealias RemoteApi = BackendApi.Match
    
    init(matchModel: BackendData.Match) {
        self.remoteMatchModel = matchModel
    }
    private var remoteMatchModel : RemoteData
    
    var id : Int { remoteMatchModel.Idt }
    var rankOrder : Int { remoteMatchModel.Num }
    var stadium : String { remoteMatchModel.Stade_Nom }
    var city : String { remoteMatchModel.Ville_Nom }
    var localTeamId : Int { remoteMatchModel.team_idt_Dom }
    var localTeamName : String { remoteMatchModel.Nom_Dom }
    var localTeamScore : Int { remoteMatchModel.Score_Dom }
    var externalTeamId : Int { remoteMatchModel.team_idt_Ext }
    var externalTeamName : String { remoteMatchModel.Nom_Ext }
    var externalTeamScore : Int { remoteMatchModel.Score_Ext }
    var competitionGroup : String? { remoteMatchModel.Grp_Cod }
    var competitionPhaseDescription : String { remoteMatchModel.Journee_Lib }

    var localTeamScoreBet : Int?
    var externalTeamScoreBet : Int?
    
    var eventDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let usefulDate = formatter.date(from: remoteMatchModel.DteHre)
        return usefulDate
    }
}
