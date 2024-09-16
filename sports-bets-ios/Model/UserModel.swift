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
    
    typealias Contents = [String:String]
    
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
    
    init(fromContents dic:Contents) throws {
        let getValue = {
            key in
            guard let value = dic[key] else {
                throw CocoaError(.coderValueNotFound)
            }
            return value
        }
        self.token = try getValue("token")
        self.username = try getValue("username")
        self.email = try getValue("email")
        self.title = try getValue("title")
        self.role = try getValue("role")
        self.firstName = try getValue("firstName")
        self.lastName = try getValue("lastName")
    }
    
    func contents() -> Contents {
        var dic : Contents = [:]
        dic["token"] = token
        dic["username"] = username
        dic["email"] = email
        dic["title"] = title
        dic["role"] = role
        dic["firstName"] = firstName
        dic["lastName"] = lastName
        return dic
    }
}
