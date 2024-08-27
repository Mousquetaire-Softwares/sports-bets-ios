//
//  WebApiTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 26/08/2024.
//

import XCTest
@testable import sports_bets_ios

final class WebApiTests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_buildRequest_forEndpointWithGetAndQueryItems() throws {
        let testValues = (url:"http://foobar.com"
                          ,parameter1: (name: "param1", value: "value 1")
                          ,parameter2: (name: "param2", value: "value2 & 2bis"))
        let expectedRequestUrl = "http://foobar.com?param1=value%201&param2=value2%20%26%202bis"
        
        let queryItems : [URLQueryItem] = [
            URLQueryItem(name: testValues.parameter1.name, value: testValues.parameter1.value)
            ,URLQueryItem(name: testValues.parameter2.name, value: testValues.parameter2.value)
        ]
        let endpointMock = WebApiEndpointMock<DTOMock>(baseUrl: URL(string: testValues.url)!
                                                       , queryItems: queryItems
                                                       , httpMethod: WebApi.HTTPMethod.GET)
        
        let sut = try WebApi.buildRequest(for: endpointMock)
        
        XCTAssertEqual(sut.url?.absoluteString, expectedRequestUrl)
        XCTAssertNil(sut.httpBody)
        XCTAssertEqual(sut.httpMethod, "GET")
    }

    func test_buildRequest_forEndpointWithPostAndBodyData() throws {
        let testValues = (url:"http://localhost:7700/api/v1/user/login"
                          ,parameter1: (name: "param1", value: "value 1")
                          ,parameter2: (name: "param2", value: "value2 & 2bis"))
        let expectedRequestUrl = testValues.url
        typealias Parameters = [String:String?]
        
        let parametersDictionary = Dictionary(uniqueKeysWithValues: [testValues.parameter1, testValues.parameter2])
        let endpointMock = WebApiEndpointMock<DTOMock>(baseUrl: URL(string: testValues.url)!
                                                       , queryItems: nil
                                                       , httpMethod: .POST(parametersAsJsonObject: parametersDictionary))
        
        let sut = try WebApi.buildRequest(for: endpointMock)
        
//        print(sut.url!)
//        print("\(String(decoding: sut.httpBody!, as: UTF8.self))")
//        print(sut.allHTTPHeaderFields!)
        
        let sutBodyContent = try JSONDecoder().decode(Parameters.self, from: sut.httpBody!)
        
        XCTAssertEqual(sut.url?.absoluteString, expectedRequestUrl)
        XCTAssertEqual(sutBodyContent, parametersDictionary)
        XCTAssertEqual(sut.httpMethod, "POST")
        XCTAssertEqual(sut.allHTTPHeaderFields?["Content-Type"], "application/json")
    }

}
