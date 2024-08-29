//
//  UserLoginView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import SwiftUI

struct UserLoginView: View {
    @ObservedObject var userLogin : UserLogin
    @Environment(\.dismiss) private var dismiss
    private var actionDisabled : Bool {
        userLogin.userLogged.user != nil || userLogin.apiState.isFetching
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Login.Title".localized)
                    .font(.title)
                loginInputForm
                    .foregroundColor(actionDisabled ? Color.gray : nil)
                    .disabled(actionDisabled)
                
                Spacer()
                submitResult
                Spacer()
                Spacer()
                Spacer()
            }
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel", role: .cancel) {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .primaryAction) {
                    submit
                        .disabled(actionDisabled)
                }
            }
        }
        .padding(40) //ScaledMetric(wrappedValue: 20, relativeTo: .title))
        
        
    }
    
    @ViewBuilder
    var loginInputForm : some View {
        email
            .padding(.top, 20)
        Divider()
        password
            .padding(.top, 20)
        Divider()
    }
    
    var email : some View {
        TextField(
            "Login.EmailField.Title".localized,
            text: $userLogin.email
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
    }
    
    var password : some View {
        SecureField(
            "Login.PasswordField.Title".localized,
            text: $userLogin.password
        )
    }
    
    @ViewBuilder 
    var submit : some View {
        if userLogin.apiState.isFetching {
            ProgressView()
        } else {
            Button {
                Task { await userLogin.submitEmailPasswordForLogin() }
            } label : {
                Text("Login.Action.Submit".localized)
            }
        }
    }
    
    @ViewBuilder
    var submitResult : some View {
        Text(userLogin.loginResult.unwrappedDescriptionOrEmpty)
    }
    
    @ViewBuilder
    var actionLogin : some View {
//        if case .failed(let message) = userLogin.apiState {
//            Text(message)
//        }
        Button {
            Task { await userLogin.submitEmailPasswordForLogin() }
        } label: {
            Text("Login.LoginButton.Title".localized)
                .font(.system(size: 24, weight: .bold, design: .default))
                .frame(maxWidth: .infinity, maxHeight: 60)
                .foregroundColor(Color.white)
                .background(Color.blue)
                .cornerRadius(10)
        }
    }
}

#Preview {
    let userLogged = UserLogged()
    return UserLoginView(userLogin: UserLogin(userLogged: userLogged))
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
