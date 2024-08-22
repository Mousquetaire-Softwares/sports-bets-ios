//
//  Competition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

struct CompetitionModel : Identifiable {
    typealias RemoteData = BackendData.Competition
    typealias RemoteApi = BackendApi.Competition
    
    
    init(remoteData: BackendData.Competition) {
        self.remoteData = remoteData
    }
    private var remoteData : RemoteData
    
    var id : Int { remoteData.idt }
    var code : String { remoteData.cod }
    var description : String { remoteData.lib }
}
