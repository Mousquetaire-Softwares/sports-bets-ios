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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                Text("Login.Title".localized)
                    .font(.title)
                email
                    .padding(.top, 20)
                Divider()
                password
                    .padding(.top, 20)
                Divider()
                Spacer()
                progress
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
                    Button("Try!", action: userLogin.login)
                }
            }
        }
        .padding(40) //ScaledMetric(wrappedValue: 20, relativeTo: .title))
        
        
    }
    
    var username : some View {
        TextField(
            "Login.UsernameField.Title".localized,
            text: $userLogin.username
        )
        .autocapitalization(.none)
        .disableAutocorrection(true)
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
    var progress : some View {
        if userLogin.apiState.isFetching {
            ProgressView()
        } else {
            Text(userLogin.loginResult.unwrappedDescriptionOrEmpty)
        }
            
    }
    
    @ViewBuilder
    var actionLogin : some View {
//        if case .failed(let message) = userLogin.apiState {
//            Text(message)
//        }
        Button(
            action: userLogin.login,
            label: {
                Text("Login.LoginButton.Title".localized)
                    .font(.system(size: 24, weight: .bold, design: .default))
                    .frame(maxWidth: .infinity, maxHeight: 60)
                    .foregroundColor(Color.white)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
        )
    }
}

#Preview {
    UserLoginView(userLogin: UserLogin())
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
    func localized(arguments: CVarArg...) -> String {
        return String(format: self.localized, arguments: arguments)
    }
}
