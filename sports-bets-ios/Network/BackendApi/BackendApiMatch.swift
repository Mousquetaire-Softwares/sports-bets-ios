//
//  BackendApiMatch.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 23/08/2024.
//

import Foundation

extension BackendApi {
    struct Match : WebApiNode {
        static let baseUrl = BackendApi.baseUrl.appending(path: "matches")
        
        struct GetAll : WebApiEndpoint {
            
            let competitionId: Int
            
            let baseUrl: URL = Match.baseUrl
            
            var queryItems: [URLQueryItem]? { [URLQueryItem(name: "cmpEdt", value: "\(competitionId)")] }
            
            let httpMethod : HTTPMethod = .GET
            
            static func decodeResponse(_ data: Data) throws -> [ResponseDTO] {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                return try jsonDecoder.decode([ResponseDTO].self, from: data)
            }
        }
    }
}

extension BackendApi.Match.GetAll {
    struct ResponseDTO : Codable {
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
        let Score_Dom : Int?
        let MatchTeam_Idt_Ext : Int
        let team_idt_Ext : Int
        let Nom_Ext : String
        let Score_Ext : Int?
        let Grp_Cod : String?
        let Journee_Lib : String
    }
}
