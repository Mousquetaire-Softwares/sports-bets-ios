//
//  UserLogin.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import Foundation

class UserLogin : ObservableObject {
    
    @Published var username : String = ""
    @Published var email : String = ""
    @Published var password : String = ""
    
    @Published var loginResult : String?
    
    @Published var apiState : ApiState = .notInitialized
    
    func login() {
        apiState = .fetching
        loginResult = nil
        Task {
            await callApiForLogin()
        }
    }
    private func callApiForLogin() async {
        do {
            let data = try await WebApi.fetchData(for: BackendApi.User.Login(userEmail: email, userPassword: password))
            print("\(String(decoding: data, as: UTF8.self))")
            
            let loginResponse = try BackendApi.User.Login.decodeResponse(data)
            Task {
                @MainActor in
                if loginResponse.success {
                    loginResult = "YAY !"
                    username = loginResponse.user.firstName
                } else {
                    loginResult = "Baaaad password"
                }
                apiState = .loaded
            }
        } catch {
            Task {
                @MainActor in
                apiState = .failed(error.localizedDescription)
                loginResult = "The church have rejected this"
            }
        }
        
    }
}
