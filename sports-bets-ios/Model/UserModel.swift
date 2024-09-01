//
//  UserModel.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 27/08/2024.
//

import Foundation

struct UserModel {
    typealias RemoteApi = BackendApi.User.Login
    typealias RemoteUserDTO = RemoteApi.DTO.User
    
    var token: String
    
    let username, email, title, role: String
    let firstName, lastName: String
    
    init(from userDto: RemoteUserDTO, token: String) {
        self.token = token
        self.username = userDto.username
        self.email = userDto.email
        self.title = userDto.title
        self.role = userDto.role
        self.firstName = userDto.firstName
        self.lastName = userDto.lastName
    }
}
