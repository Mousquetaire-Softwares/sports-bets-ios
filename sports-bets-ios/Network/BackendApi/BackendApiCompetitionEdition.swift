//
//  BackendApiCompetitionEdition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 16/09/2024.
//

import Foundation

extension BackendApi {
    enum CompetitionEdition : WebApiNode {
        static var baseUrl : URL { BackendApi.baseUrl.appending(path: "cmpedt") }
        
        struct GetAll : WebApiEndpoint, CallableApi {
            typealias ResponseDTO = [ApiResponse.Competition]
            
            var baseUrl: URL { CompetitionEdition.baseUrl }
            let queryItems: [URLQueryItem]? = nil
            let httpMethod : WebApi.HTTPMethod = .GET
            
            // specific function to decode this response because of the formatting
            static func decodeResponse(_ jsonData: Data) throws -> ResponseDTO {
                let response = try JSONDecoder().decode(ApiResponse.self, from: jsonData)

                return response.results
//                if let data = dto.results.data(using: .utf8) {
//                    return try JSONDecoder().decode([ApiResponse.Competition].self, from: data)
//                } else {
//                    return []
//                }
            }
        }
    }
}

extension BackendApi.CompetitionEdition.GetAll {
    // DTO for the main response
    struct ApiResponse: Codable {
        let results: [Competition]
        
        enum CodingKeys: String, CodingKey {
            case results = "Results"
        }
        
        // DTO for the individual competition objects
        struct Competition: Codable {
            let idt: String
            let competition: String
            let edition: String
            let libelle: String
            let dateDebut: String
            let dateFin: String
            
            enum CodingKeys: String, CodingKey {
                case idt = "Idt"
                case competition = "Competition"
                case edition = "Edition"
                case libelle = "Libelle"
                case dateDebut = "DateDebut"
                case dateFin = "DateFin"
            }
        }
    }
}
