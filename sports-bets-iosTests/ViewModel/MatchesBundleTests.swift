//
//  MatchesBundleTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 22/08/2024.
//

import XCTest
@testable import sports_bets_ios

final class MatchesBundleTests: XCTestCase {
    typealias RemoteSut = MatchesBundle<RemoteMatchModel>
    var sutRemote : RemoteSut!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        let userParameters = UserParameters()
        sutRemote = RemoteSut(userParameters: userParameters)
        
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sutRemote = nil
    }

    func test_sutRemote_fetchMatches_withCompetitionId2() async throws {
        await sutRemote.fetchMatches(of: 2)
        XCTAssertFalse(sutRemote.matches.isEmpty)
    }
    
//    func test_sutRemote_initMatches_withRemoteDataCompetitionId2_ShouldBeNotEmpty() async throws {
//        // FIXME: RemoteMatchModel repetition - should be RemoteSut.Match
//        let jsonData = try await WebApi.fetchData(for: RemoteMatchModel.RemoteApi.GetAll(competitionId: 2))
//        let initializedMatches = try sutRemote.initMatches(from: jsonData)
//        
//        XCTAssertFalse(initializedMatches.isEmpty)
//    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
