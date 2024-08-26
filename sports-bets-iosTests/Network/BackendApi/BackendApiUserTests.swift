//
//  BackendApiUserTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 23/08/2024.
//

import XCTest
@testable import sports_bets_ios

final class BackendApiUserTests: XCTestCase {
    typealias Sut = BackendApi.User
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

//    func test_WebApiFetchData_forSutLogin() async throws {
//        let data = try await WebApi.fetchData(for: Sut.Login(userEmail: "fraternite76-bartman@yahoo.fr", userPassword: "fraternite76-bartman@yahoo.fr"))
//        print("\(String(decoding: data, as: UTF8.self))")
//        let remoteDTO = try Sut.Login.decodeResponse(data)
//        print(remoteDTO)
//        
//        XCTAssertTrue(remoteDTO.success)
//    }

}
