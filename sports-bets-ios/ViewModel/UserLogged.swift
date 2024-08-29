//
//  UserLogged.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 29/08/2024.
//

import Foundation

class UserLogged : ObservableObject {
    @Published private(set) var user : UserModel?
    var token : String? { user?.token }
    var isSet : Bool { user != nil }
    
    func setUser(_ user: UserModel?) {
        self.user = user
    }
}
