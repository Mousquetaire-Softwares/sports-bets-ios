//
//  Competition.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import Foundation

struct Competition : Decodable, Identifiable {
    var id : Int { idt }
    let idt : Int
    let cod : String
    let lib : String
    let etFin : String
    let etGrp : String
}
