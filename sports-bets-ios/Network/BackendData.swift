//
//  BackendData.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

struct BackendData {
    struct Match : Codable
    {
        let Idt : Int
        let Num : Int
        let Hre : String
        let Stade_Nom : String
        let Stade_Capacite : Int
        let Ville_Nom : String
        let Fnt_cod : String
        let Dte : String
        let DteHre : String
        let MatchTeam_Idt_Dom : Int
        let team_idt_Dom : Int
        let Nom_Dom : String
        let Score_Dom : Int
        let MatchTeam_Idt_Ext : Int
        let team_idt_Ext : Int
        let Nom_Ext : String
        let Score_Ext : Int
        let Grp_Cod : String?
        let Journee_Lib : String
    }
    
    struct Competition : Decodable {
        let idt : Int
        let cod : String
        let lib : String
        let etFin : String
        let etGrp : String
    }
}
