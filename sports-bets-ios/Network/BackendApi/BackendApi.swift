//
//  APIEndPoint.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation


enum BackendApi : WebApiNode {
    static var baseUrl = DefaultValues.baseUrl
}

extension BackendApi {
    struct DefaultValues {
        //    static let baseUrl = URL(string: "https://backend.yuumi-soft.fr/sports/api/v1")!
        static let baseUrl = URL(string: "http://localhost:7700/api/v1")!
    }
}


