//
//  BackendApiMatch.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 23/08/2024.
//

import Foundation

extension BackendApi {
    struct Match : WebApiNode {
        static var baseUrl : URL { BackendApi.baseUrl.appending(path: "matches") }
        
        struct GetAll : WebApiEndpoint, CallableApi {
            typealias ResponseDTO = [DTO]
            
            init(of competitionEditionId: String) {
                self.competitionEditionId = competitionEditionId
            }
            
            let competitionEditionId: String
            var baseUrl: URL { Match.baseUrl }
            var queryItems: [URLQueryItem]? { [URLQueryItem(name: "cmpEdt", value: competitionEditionId)] }
            let httpMethod : WebApi.HTTPMethod = .GET
            var token: String? = nil
            
            static func decodeResponse(_ data: Data) throws -> ResponseDTO {
                let jsonDecoder = JSONDecoder()
                jsonDecoder.dateDecodingStrategy = .iso8601
                return try jsonDecoder.decode(ResponseDTO.self, from: data)
            }
        }
        
        
        struct PostUserBet : WebApiEndpoint, CallableApi {
            
            typealias ResponseDTO = [DTO]
            
            init(token:String, matchId: Int, teamId: Int, scoreBet: Int) {
                self.token = token
                let parameterDictionary = ["match": matchId, "matchteam": teamId, "value": scoreBet]
                httpMethod = .POST(parametersAsJsonObject: parameterDictionary)
            }
            
            var baseUrl: URL { Match.baseUrl }
            var queryItems: [URLQueryItem]? = nil
            let httpMethod : WebApi.HTTPMethod
            var token: String?

        }
    }
}

extension BackendApi.Match.GetAll {
    struct DTO : Codable {
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
extension BackendApi.Match.PostUserBet {
    struct DTO : Codable {
        
    }
}
