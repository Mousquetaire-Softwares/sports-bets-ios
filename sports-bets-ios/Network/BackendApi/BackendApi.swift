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


extension BackendApi {
    enum User : WebApiNode {
        static let baseUrl = BackendApi.baseUrl.appending(path: "user")
    }
}


