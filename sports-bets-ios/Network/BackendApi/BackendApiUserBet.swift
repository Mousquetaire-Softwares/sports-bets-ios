//
//  BackendApiUserBet.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 16/09/2024.
//

import Foundation

extension BackendApi {
    enum UserBet : WebApiNode {
        static var baseUrl : URL { BackendApi.baseUrl.appending(path: "usrbet") }
        
        struct Get : WebApiEndpoint, CallableApi {
            typealias ResponseDTO = DTO
            
            init(token: String, username: String, competitionEditionId: Int, matchId: Int) {
                self.token = token
                
                queryItems = [
                    URLQueryItem(name: "cmpedt_idt", value: competitionEditionId.description)
                    ,URLQueryItem(name: "username", value: username)
                    ,URLQueryItem(name: "match_idt", value: matchId.description)
                ]
                httpMethod = .GET
            }
            
            var baseUrl: URL { BackendApi.UserBet.baseUrl }
            var queryItems: [URLQueryItem]?
            var httpMethod : WebApi.HTTPMethod
            var token: String?
            
            
        }
    }
}

extension BackendApi.UserBet.Get {
    struct DTO : Codable {
//        let success: Bool
//        let user: User
//        let token: String
//        
//        struct User: Codable {
//            let username, email, title, role: String
//            let firstName, lastName: String
//            let verified: Bool
//            let verifiedDate, verificationToken: String
//            
//            enum CodingKeys: String, CodingKey {
//                case username, email
//                case title = "Title"
//                case role, firstName, lastName, verified, verifiedDate, verificationToken
//            }
//        }
    }
}
