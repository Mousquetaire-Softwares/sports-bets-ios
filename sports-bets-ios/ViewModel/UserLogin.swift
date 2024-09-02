//
//  UserLogin.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import Foundation

class UserLogin : ObservableObject {
    typealias Api = BackendApi.User.Login
    private(set) var userLogged : UserLogged?

    @Published var email : String = "" {
        didSet {
            print(oldValue)
        }
    }
    @Published var password : String = ""
    @Published var apiState : ApiState = .notInitialized
    @Published var loginResult : LoginResult = .none
    
    var loginEnabled : Bool {
        userLogged != nil 
        && userLogged?.isSet == false
        && apiState.isFetching == false
    }
    
    func prepare(for userLogged:UserLogged) {
        self.userLogged = userLogged
        password = ""
        email = ""
        apiState = .notInitialized
        loginResult = .none
    }
    
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
            
            let apiResponse = try BackendApi.User.Login.decodeResponse(data)
            if apiResponse.success {
                await setSubmitSuccess(apiResponse: apiResponse)
            } else {
                await setSubmitRejected()
            }
        } catch {
            await setSubmitError(errorMessage: error.localizedDescription)
        }
    }
    @MainActor
    private func setSubmitSuccess(apiResponse:Api.ResponseDTO) {
        userLogged?.setUser(UserModel(from: apiResponse.user, token: apiResponse.token))
        loginResult = .success(welcomeMessage: "Login.Success".localized)
        apiState = .loaded
    }
    @MainActor
    private func setSubmitRejected() {
        userLogged?.setUser(nil)
        loginResult = .rejected(errorMessage: "Login.Failed".localized)
        apiState = .loaded
    }
    @MainActor
    private func setSubmitError(errorMessage:String) {
        userLogged?.setUser(nil)
        loginResult = .rejected(errorMessage: "Login.Failed".localized)
        apiState = .failed(errorMessage)
    }
}
