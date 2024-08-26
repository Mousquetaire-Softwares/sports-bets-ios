//
//  ApiRequest.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation


enum HTTPMethod {
    typealias Parameters = [String:String]
    case GET
    case POST(parametersAsJsonObject:Any)
    case PUT
    case DELETE
    
    var URLRequestValue: String {
        switch(self) {
        case .GET: "GET"
        case .POST: "POST"
        case .PUT: "PUT"
        case .DELETE: "DELETE"
        }
    }

}

enum WebServiceError: Error {
    case invalidResponse(Data, URLResponse)
    case statusCode(Int, Data)
}


protocol WebApiNode {
    static var baseUrl : URL { get }
}

protocol WebApiEndpoint {
    associatedtype ResponseDTO
    
    var baseUrl: URL { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod : HTTPMethod { get }
    static func decodeResponse(_ data: Data) throws -> ResponseDTO
}

extension WebApiEndpoint where ResponseDTO : Decodable {
    static func decodeResponse(_ data: Data) throws -> ResponseDTO {
        return try JSONDecoder().decode(ResponseDTO.self, from: data)
    }
}

struct WebApi {
    
    static func buildRequest(for endpoint: some WebApiEndpoint) throws -> URLRequest {
        var request = URLRequest(url: try endpoint.url)
        
        request.httpMethod = endpoint.httpMethod.URLRequestValue
        switch(endpoint.httpMethod) {
        case .POST(let parameters):
            let httpBody = try JSONSerialization.data(
                withJSONObject: parameters,
                options: []
            )
            request.httpBody = httpBody
            
            request.allHTTPHeaderFields = request.allHTTPHeaderFields ?? [:]
            request.allHTTPHeaderFields!["Content-Type"] = "application/json"
        default:
            break
        }
        
        // Add any additional headers if needed
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        return request
    }
    
    static func fetchData(for endpoint: some WebApiEndpoint) async throws -> Data {
        let request = try buildRequest(for: endpoint)
        
        guard let url = request.url else {
            throw URLError(.badURL)
        }
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw WebServiceError.invalidResponse(data, response)
        }
        
        guard 200 ..< 300 ~= statusCode else {
            throw WebServiceError.statusCode(statusCode, data)
        }
        
        sleep(1)
        
        return data
    }
}

extension WebApiEndpoint {
    var url : URL {
        get throws {
            guard var components = URLComponents(url: baseUrl, resolvingAgainstBaseURL: false) else {
                throw URLError(.badURL)
            }
            components.queryItems = queryItems
            
            // work-around, what Apple advises if your queries may include a + character and you have a server that interprets them as spaces
            components.percentEncodedQuery = components.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
            
            guard let url = components.url else {
                throw URLError(.badURL)
            }
            return url
        }
    }
}

extension URLComponents {
    
}
