//
//  Competition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

struct CompetitionModel : Identifiable {
    typealias RemoteDTO = BackendDTO.Competition
    typealias RemoteApi = BackendApi.Competition
    
    
    init(remoteData: BackendDTO.Competition) {
        self.remoteData = remoteData
    }
    private var remoteData : RemoteDTO
    
    var id : Int { remoteData.idt }
    var code : String { remoteData.cod }
    var description : String { remoteData.lib }
}
