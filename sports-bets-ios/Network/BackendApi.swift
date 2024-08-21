//
//  APIEndPoint.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

protocol WebApiNode {
    static var baseUrl : URL { get }
}

protocol WebApiEndpoint {
    var baseUrl: URL { get }
    var queryItems: [URLQueryItem]? { get }
}

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
        static let baseUrl = BackendApi.baseUrl.appendingPathComponent("competition")
        case getAll
        
        var baseUrl: URL {
            switch(self) {
            case .getAll:
                return Self.baseUrl
            }
        }
        var queryItems: [URLQueryItem]? {
            return nil
        }

        
    }
}
extension BackendApi {
    enum Match : WebApiNode, WebApiEndpoint {
        static let baseUrl = BackendApi.baseUrl.appendingPathComponent("matches")
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

        
    }
}

extension BackendApi {
    enum CompetitionEdition : WebApiNode {
        static let baseUrl = BackendApi.baseUrl.appendingPathComponent("cmpEdt")

        static func getAll(ofCompetitionId id: Int) -> URL {
            baseUrl.appendingPathComponent("?Idt=\(id)")
        }
        
    }
}


struct test {
    static var url : URL? = try? BackendApi.Match.getAll(ofCompetitionId: 3).url
    static var url2 : URL? = try? BackendApi.Competition.getAll.url
    static var url3 : URL = BackendApi.CompetitionEdition.getAll(ofCompetitionId: 3)
}
