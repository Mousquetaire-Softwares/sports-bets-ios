//
//  BackendApiUser.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 23/08/2024.
//

import Foundation

extension BackendApi {
    enum User : WebApiNode {
        static var baseUrl : URL { BackendApi.baseUrl.appending(path: "user") }
        
        struct Login : WebApiEndpoint, CallableApi {
            typealias ResponseDTO = DTO
            
            init(userEmail: String, userPassword: String) {
                self.userEmail = userEmail
                self.userPassword = userPassword
                
                let parameterDictionary = ["email": userEmail, "password": userPassword]
                httpMethod = .POST(parametersAsJsonObject: parameterDictionary)
            }
            
            let userEmail: String
            let userPassword: String
            
            var baseUrl: URL { BackendApi.User.baseUrl.appending(path: "login") }
            
            var queryItems: [URLQueryItem]?
            var httpMethod : WebApi.HTTPMethod
            
            
        }
    }
}

extension BackendApi.User.Login {
    struct DTO : Codable {
        let success: Bool
        let user: User
        let token: String
        
        struct User: Codable {
            let username, email, title, role: String
            let firstName, lastName: String
            let verified: Bool
            let verifiedDate, verificationToken: String
            
            enum CodingKeys: String, CodingKey {
                case username, email
                case title = "Title"
                case role, firstName, lastName, verified, verifiedDate, verificationToken
            }
        }
    }
}
