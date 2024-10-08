//
//  CompetitionsLibraryTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 22/08/2024.
//

import XCTest
@testable import sports_bets_ios

final class CompetitionsLibraryTests: XCTestCase {
    var sutRemote : CompetitionsLibrary!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        sutRemote = CompetitionsLibrary()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        sutRemote = nil
    }


    func test_sutRemote_fetchMatches_withCompetitionId2() async throws {
        await sutRemote.fetchCompetitions()
        XCTAssertFalse(sutRemote.competitions.isEmpty)
    }
}
