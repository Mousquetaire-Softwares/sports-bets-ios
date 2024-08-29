//
//  UserLogin.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import Foundation

class UserLogin : ObservableObject {
    typealias Api = BackendApi.User.Login
    let userLogged : UserLogged

    init(userLogged: UserLogged) {
        self.userLogged = userLogged
    }
    
    @Published var email : String = ""
    @Published var password : String = ""
    @Published var apiState : ApiState = .notInitialized
    @Published var loginResult : LoginResult = .none
    
    enum LoginResult : CustomStringConvertible {
        
        case none
        case success(welcomeMessage:String)
        case rejected(errorMessage:String)

        var description: String {
            switch(self) {
            case .none: return .empty
            case .rejected(let errorMessage): return errorMessage
            case .success(let welcomeMessage): return welcomeMessage
            }
        }
    }
    
    @MainActor
    func submitEmailPasswordForLogin() async {
        apiState = .fetching
        await callApiForLogin(email: email, password: password)
    }
    private func callApiForLogin(email submitEmail:String, password submitPassword:String) async {
        do {
            let data = try await WebApi.fetchData(for: BackendApi.User.Login(userEmail: submitEmail, userPassword: submitPassword))
            print("\(String(decoding: data, as: UTF8.self))")
            
            let apiResponse = try BackendApi.User.Login.decodeResponse(data)
            if apiResponse.success {
                setSubmitSuccess(apiResponse: apiResponse)
            } else {
                setSubmitRejected()
            }
        } catch {
            setSubmitError(errorMessage: error.localizedDescription)
        }
    }
    
    private func setSubmitSuccess(apiResponse:Api.ResponseDTO) {
        Task {
            @MainActor in
            userLogged.setUser(UserModel(from: apiResponse.user, token: apiResponse.token))
            loginResult = .success(welcomeMessage: "Login.Success".localized)
            apiState = .loaded
        }
    }
    private func setSubmitRejected() {
        Task {
            @MainActor in
            userLogged.setUser(nil)
            loginResult = .rejected(errorMessage: "Login.Failed".localized)
            apiState = .loaded
        }
    }    
    private func setSubmitError(errorMessage:String) {
        Task {
            @MainActor in
            userLogged.setUser(nil)
            loginResult = .rejected(errorMessage: "Login.Failed".localized)
            apiState = .failed(errorMessage)
        }
    }
}
