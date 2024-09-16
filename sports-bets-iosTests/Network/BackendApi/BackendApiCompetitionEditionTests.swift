//
//  BackendApiCompetitionEditionTests.swift
//  sports-bets-iosTests
//
//  Created by Steven Morin on 16/09/2024.
//

import XCTest
@testable import sports_bets_ios

final class BackendApiCompetitionEditionTests: XCTestCase {
    typealias RemoteApi = BackendApi.CompetitionEdition
    
    let jsonData1 =  """
        {"Results":"[\"{\\\"Idt\\\": \\\"3\\\", \\\"Competition\\\": \\\"UEFA-EURO\\\", \\\"Edition\\\": \\\"17ème édition\\\", \\\"Libelle\\\": \\\"Championnat d'Europe\\\", \\\"DateDebut\\\": \\\"2024-06-14\\\", \\\"DateFin\\\": \\\"2024-07-15\\\"}\", \"{\\\"Idt\\\": \\\"4\\\", \\\"Competition\\\": \\\"UEFACL\\\", \\\"Edition\\\": \\\"70ème édition\\\", \\\"Libelle\\\": \\\"UEFA Champion's League\\\", \\\"DateDebut\\\": \\\"2024-09-17\\\", \\\"DateFin\\\": \\\"2025-05-31\\\"}\"]"}
        """.data(using: .utf8)!
    
    let jsonData2 = """
        {"Results":
            [{"Idt": "3"
                , "Competition": "UEFA-EURO"
                , "Edition": "17ème édition"
                , "Libelle": "Championnat d'Europe"
                , "DateDebut": "2024-06-14"
                , "DateFin": "2024-07-15"},
            {"Idt": "4"
                , "Competition": "UEFACL"
                , "Edition": "70ème édition"
                , "Libelle": "UEFA Champion's League"
                , "DateDebut": "2024-09-17"
                , "DateFin": "2025-05-31"}
            ]
        }
        """.data(using: .utf8)!
    
    let jsonData3 = """
        {"Results":[{"Competition":"","Libelle":"","DateDebut":"","DateFin":"","Edition":"","Idt":""},{"Competition":"","Edition":"","DateDebut":"","Libelle":"","DateFin":"","Idt":""}]}
        """.data(using: .utf8)!
    
    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func test_GetAll_initDTO_WithFictiveJsons() throws {
//        let decodedDTO1 = try RemoteApi.GetAll.decodeResponse(jsonData1)
        let decodedDTO2 = try RemoteApi.GetAll.decodeResponse(jsonData2)
        let decodedDTO3 = try RemoteApi.GetAll.decodeResponse(jsonData3)
//        XCTAssertFalse(decodedDTO1.isEmpty)
        XCTAssertFalse(decodedDTO2.isEmpty)
        XCTAssertFalse(decodedDTO3.isEmpty)
        print(decodedDTO2)
        
    }
    
//    func test_GetAll_initDTO_WithLocalValues() throws {
//        typealias DTO = RemoteApi.GetAll.DTO
//        let localDTO = DTO(results: [
//            DTO.Competition(idt: .empty, competition: .empty, edition: .empty, libelle: .empty, dateDebut: .empty, dateFin: .empty)
//            ,DTO.Competition(idt: .empty, competition: .empty, edition: .empty, libelle: .empty, dateDebut: .empty, dateFin: .empty)
//            ])
//        let encodedDTO = try JSONEncoder().encode(localDTO)
//        print(String(data: encodedDTO, encoding: .utf8)!)
//    }
    
//    func test_GetAll_WithWebApiFetchDataRealCall() async throws {
//        let data = try await WebApi.fetchData(for: RemoteApi.GetAll())
//        print("\(String(decoding: data, as: UTF8.self))")
////        let remoteDTO = try Sut.Login.decodeResponse(data)
////        print(remoteDTO)
////        
////        XCTAssertTrue(remoteDTO.success)
//    }

}
