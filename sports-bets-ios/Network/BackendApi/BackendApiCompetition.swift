//
//  BackendApiCompetition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 23/08/2024.
//

import Foundation

extension BackendApi {
    enum Competition : WebApiNode {
        static let baseUrl = BackendApi.baseUrl.appending(path: "competition")
        
        struct GetAll : WebApiEndpoint {
            typealias ResponseDTO = [DTO]
            
            let baseUrl: URL = Competition.baseUrl
            let queryItems: [URLQueryItem]? = nil
            let httpMethod : WebApi.HTTPMethod = .GET
        }
    }
}

//
//extension RawRepresentable where RawValue == String, Self : WebApi {
//    var url: URL {
//        return Self.baseUrl.appendingPathComponent(rawValue)
//    }
//}




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


extension BackendApi.Competition.GetAll {
    struct DTO : Codable {
        let idt : Int
        let cod : String
        let lib : String
        let etFin : String
        let etGrp : String
    }
}
