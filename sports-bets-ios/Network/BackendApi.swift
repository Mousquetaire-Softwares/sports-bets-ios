//
//  APIEndPoint.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation


enum BackendApi : WebApiNode {
    static let baseUrl = URL(string: "http://localhost:7700/api/v1")!
    
}
//
//extension RawRepresentable where RawValue == String, Self : WebApi {
//    var url: URL {
//        return Self.baseUrl.appendingPathComponent(rawValue)
//    }
//}


extension BackendApi {
    enum Competition : WebApiNode, WebApiEndpoint {
        static let baseUrl = BackendApi.baseUrl.appending(path: "competition")
        case getAll
        
        var baseUrl: URL {
            switch(self) {
            case .getAll:
                return Self.baseUrl
            }
        }
        var queryItems: [URLQueryItem]? { nil }

        var httpMethod : HTTPMethod { .GET }
    }
}
extension BackendApi {
    enum Match : WebApiNode, WebApiEndpoint {
        static let baseUrl = BackendApi.baseUrl.appending(path: "matches")
        case getAll(ofCompetitionId: Int)

        
        var baseUrl: URL {
            switch(self) {
            case .getAll:
                return Self.baseUrl
            }
        }
        var queryItems: [URLQueryItem]? {
            switch(self) {
            case .getAll(let competitionId):
                return [URLQueryItem(name: "cmpEdt", value: "\(competitionId)")]
            }
        }

        var httpMethod : HTTPMethod { .GET }
    }
}

//extension BackendApi {
//    enum CompetitionEdition : WebApiNode {
//        static let baseUrl = BackendApi.baseUrl.appendingPathComponent("cmpEdt")
//
//        static func getAll(ofCompetitionId id: Int) -> URL {
//            baseUrl.appendingPathComponent("?Idt=\(id)")
//        }
//        
//        var httpMethod : HTTPMethod { .GET }
//    }
//}

extension BackendApi {
    enum User : WebApiNode, WebApiEndpoint {
        static let baseUrl = BackendApi.baseUrl.appending(path: "user")
        case login(email:String, password:String)

        
        var baseUrl: URL {
            switch(self) {
            case .login:
                return Self.baseUrl.appending(path: "login")
            }
        }
        var queryItems: [URLQueryItem]? { nil }
        
        
        var httpMethod : HTTPMethod { 
            switch(self) {
            case .login(let email, let password):
                let parameterDictionary = ["email": email, "password": password]
                return .POST(parametersAsJsonObject: parameterDictionary)
            }
        }
    }
}

