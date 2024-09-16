//
//  ApiRequest.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation


protocol WebApiNode {
    static var baseUrl : URL { get }
}


/// WebApiEndpoint
protocol WebApiEndpoint {
    associatedtype ResponseDTO
    
    var baseUrl: URL { get }
    var queryItems: [URLQueryItem]? { get }
    var httpMethod : WebApi.HTTPMethod { get }
    var token: String? { get }
    static func decodeResponse(_ data: Data) throws -> ResponseDTO
}

extension WebApiEndpoint where ResponseDTO : Decodable {
    static func decodeResponse(_ data: Data) throws -> ResponseDTO {
        return try JSONDecoder().decode(ResponseDTO.self, from: data)
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


/// WebApi static functions
struct WebApi {
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

    enum FetchingError: Error {
        case invalidResponse(Data, URLResponse)
        case statusCode(Int, Data)
    }


    internal static func buildRequest(for endpoint: some WebApiEndpoint) throws -> URLRequest {
        var request = URLRequest(url: try endpoint.url)
        
        request.httpMethod = endpoint.httpMethod.URLRequestValue
        switch(endpoint.httpMethod) {
        case .POST(let parameters):
            let httpBody = try JSONSerialization.data(
                withJSONObject: parameters,
                options: []
            )
            request.httpBody = httpBody
            
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        default:
            break
        }
        
        // Add any additional headers if needed
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // if a token is provided in the Api EndPoint, we add it as a Bearer in http header
        if let token = endpoint.token {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        return request
    }
    
    internal static func fetchData(from request: URLRequest) async throws -> Data {
        #if DEBUG
//        print("calling url : \(request.url.unwrappedDescriptionOrEmpty)")
        sleep(1)
        #endif

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            throw FetchingError.invalidResponse(data, response)
        }
        
        guard 200 ..< 300 ~= statusCode else {
            throw FetchingError.statusCode(statusCode, data)
        }
        
        return data
    }
    
    static func fetchData(for endpoint: some WebApiEndpoint) async throws -> Data {
        let request = try buildRequest(for: endpoint)
        
        return try await fetchData(from: request)
    }
}
