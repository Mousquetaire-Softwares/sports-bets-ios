//
//  MatchTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 21/08/2024.
//

import XCTest
@testable import sports_bets_ios

final class MatchModelTests: XCTestCase {
    let jsonData1 = """
            {"Idt":646,"Num":7,"Hre":"21:00:00","Stade_Nom":"MHPArena","Stade_Capacite":60441,"Ville_Nom":"Stuttgart","Fnt_cod":"GER","Dte":"2024-06-16","DteHre":"2024-06-16T16:00:00.000Z","MatchTeam_Idt_Dom":930,"team_idt_Dom":48,"Nom_Dom":"Serbie","Score_Dom":0,"MatchTeam_Idt_Ext":931,"team_idt_Ext":39,"Nom_Ext":"Angleterre","Score_Ext":1,"Grp_Cod":"C","Journee_Lib":"Phase de Groupe - Journée 1"}
            """.data(using: .utf8)!
    var remoteSut : RemoteMatchModel!

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        remoteSut = try initRemoteMatch(from: jsonData1)
    }
    
    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        remoteSut = nil
    }

    func initRemoteMatch(from data:Data) throws -> RemoteMatchModel {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        let backendData = try decoder.decode(RemoteMatchModel.RemoteData.self, from: data)
        return RemoteMatchModel(matchModel: backendData)
    }
        
    func test_DteHreDate_ShouldNotBeNil() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
        // Any test you write for XCTest can be annotated as throws and async.
        // Mark your test throws to produce an unexpected failure when your test encounters an uncaught error.
        // Mark your test async to allow awaiting for asynchronous code to complete. Check the results with assertions afterwards.
        XCTAssertNotNil(remoteSut.eventDate)
    }
//
//    func testPerformanceExample() throws {
//        // This is an example of a performance test case.
//        self.measure {
//            // Put the code you want to measure the time of here.
//        }
//    }

}
