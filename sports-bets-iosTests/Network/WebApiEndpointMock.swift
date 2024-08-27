//
//  WebApiEndpointMock.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 26/08/2024.
//

import Foundation
@testable import sports_bets_ios

struct WebApiEndpointMock<DTO : Codable> : WebApiEndpoint {
    var baseUrl: URL
    
    var queryItems: [URLQueryItem]?
    
    var httpMethod: WebApi.HTTPMethod
    
    typealias ResponseDTO = DTO
    
}

struct DTOMock : Codable {
    
}
