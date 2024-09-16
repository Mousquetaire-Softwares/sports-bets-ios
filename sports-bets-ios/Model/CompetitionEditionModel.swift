//
//  CompetitionEditionModel.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 16/09/2024.
//

import Foundation

struct CompetitionEditionModel : Identifiable {
    typealias RemoteApi = BackendApi.CompetitionEdition
    typealias RemoteDTO = RemoteApi.GetAll.ResponseDTO.Element
    
    
    init(remoteData: RemoteDTO) {
        self.remoteData = remoteData
    }
    private var remoteData : RemoteDTO
    
    var competitionCode : String { remoteData.competition }
    var id : Int { remoteData.idt }
    var description : String { remoteData.libelle }
}
