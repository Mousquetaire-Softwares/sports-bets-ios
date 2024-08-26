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
    var localTeamScore : Int? { get }
    var externalTeamId : Int { get }
    var externalTeamName : String { get }
    var externalTeamScore : Int? { get }
    var competitionGroup : String? { get }
    var competitionPhaseDescription : String { get }
    var localTeamScoreBet : Int? { get set }
    var externalTeamScoreBet : Int? { get set }
    var eventDate: Date? { get }
}

struct RemoteMatchModel : MatchModel {
    typealias RemoteApi = BackendApi.Match
    typealias RemoteDTO = RemoteApi.GetAll.DTO
    
    init(remoteData: RemoteDTO) {
        self.remoteData = remoteData
    }
    private var remoteData : RemoteDTO
    
    var id : Int { remoteData.Idt }
    var rankOrder : Int { remoteData.Num }
    var stadium : String { remoteData.Stade_Nom }
    var city : String { remoteData.Ville_Nom }
    var localTeamId : Int { remoteData.team_idt_Dom }
    var localTeamName : String { remoteData.Nom_Dom }
    var localTeamScore : Int? { remoteData.Score_Dom }
    var externalTeamId : Int { remoteData.team_idt_Ext }
    var externalTeamName : String { remoteData.Nom_Ext }
    var externalTeamScore : Int? { remoteData.Score_Ext }
    var competitionGroup : String? { remoteData.Grp_Cod }
    var competitionPhaseDescription : String { remoteData.Journee_Lib }

    var localTeamScoreBet : Int?
    var externalTeamScoreBet : Int?
    
    var eventDate: Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let usefulDate = formatter.date(from: remoteData.DteHre)
        return usefulDate
    }
}
