//
//  CallableApi.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 27/08/2024.
//

import Foundation

protocol CallableApi {
    associatedtype ResponseDTO
    func call() async throws -> ResponseDTO
}

extension CallableApi where Self : WebApiEndpoint {
    func call() async throws -> ResponseDTO
    {
        try await Self.decodeResponse(WebApi.fetchData(for: self))
    }
    
}
