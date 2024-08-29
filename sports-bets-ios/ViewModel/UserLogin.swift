//
//  UserLogin.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import Foundation

class UserLogin : ObservableObject {
    let userLogged : UserLogged

    init(userLogged: UserLogged) {
        self.userLogged = userLogged
    }
    
    @Published var email : String = ""
    @Published var password : String = ""
    
    @Published var loginResult : String?
    
    @Published var apiState : ApiState = .notInitialized
    
    @MainActor
    func submitEmailPasswordForLogin() async {
        apiState = .fetching
        loginResult = nil
        Task {
            await callApiForLogin(email: email, password: password)
        }
    }
    private func callApiForLogin(email submitEmail:String, password submitPassword:String) async {
        do {
            let data = try await WebApi.fetchData(for: BackendApi.User.Login(userEmail: submitEmail, userPassword: submitPassword))
            print("\(String(decoding: data, as: UTF8.self))")
            
            let loginResponse = try BackendApi.User.Login.decodeResponse(data)
            Task {
                @MainActor in
                if loginResponse.success {
                    loginResult = "YAY !"
                } else {
                    loginResult = "Baaaad password"
                }
                apiState = .loaded
            }
        } catch {
            Task {
                @MainActor in
                apiState = .failed(error.localizedDescription)
                loginResult = "Login.Failed".localized
            }
        }
        
    }
}
