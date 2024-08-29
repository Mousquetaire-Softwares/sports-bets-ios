//
//  UserLoginView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 26/08/2024.
//

import SwiftUI

struct UserLoginView: View {
    @ObservedObject var userLogin : UserLogin
//    @ObservedObject var userLogged : UserLogged
    @Environment(\.dismiss) private var dismiss
    
    private var actionDisabled : Bool {
        !userLogin.loginEnabled
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
        } else if case .success = userLogin.loginResult {
            EmptyView()
                .task {
                    dismiss()
                }
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
        Text(userLogin.loginResult.description)
    }
}

#Preview {
    let userLogged = UserLogged()
    let userLogin = UserLogin()
    userLogin.prepare(for: userLogged)
    return UserLoginView(userLogin: userLogin)
}

