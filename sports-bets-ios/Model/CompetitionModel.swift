//
//  Competition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

struct CompetitionModel : Identifiable {
    typealias RemoteApi = BackendApi.Competition
    typealias RemoteDTO = RemoteApi.GetAll.DTO
    
    
    init(remoteData: RemoteDTO) {
        self.remoteData = remoteData
    }
    private var remoteData : RemoteDTO
    
    var id : Int { remoteData.idt }
    var code : String { remoteData.cod }
    var description : String { remoteData.lib }
}
