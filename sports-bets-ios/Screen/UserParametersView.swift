//
//  UserParametersView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 03/09/2024.
//

import SwiftUI

struct UserParametersView: View {
    @ObservedObject var userParameters : UserParameters
    @Binding var navigationPath : NavigationPath
    
    enum Navigation : Hashable {
        case backendApiUrlEditor
    }
    
    var body: some View {
        Form {
            Section("UserParameters.BackendApiUrl") {
                NavigationLink (value: Navigation.backendApiUrlEditor) {
                    Text(userParameters.backendApiUrl.absoluteString)
                        .lineLimit(1)
                }
            }
            
            Section("UserParameters.TestingOnlySection") {
                Toggle("UserParameters.GenerateFictiveRandomBets", isOn: $userParameters.fictiveBetsData)
                Toggle("UserParameters.EmptyAllResultScores", isOn: $userParameters.allMatchesScoresAreNil)
            }

        }
        .navigationDestination(for: Navigation.self) {
            navigation in switch(navigation) {
            case Navigation.backendApiUrlEditor: BackendApiUrlEditor(userParameters: userParameters
                                                                     , navigationPath: $navigationPath)
            }
        }
        .navigationTitle("UserParameters")
    }
}


extension UserParametersView {
    struct BackendApiUrlEditor : View {
        @ObservedObject var userParameters : UserParameters
        @Binding var navigationPath : NavigationPath
        
        @State var urlString : String = .empty
        @State var badUrlString = false
        @State var submitIsEnabled = false
        
        @FocusState private var focusedTextField
        
        var body : some View {
            Form {
                TextField("Generic.EnterValidURL", text: $urlString)
                    .onAppear { urlString = userParameters.backendApiUrl.absoluteString }
                    .textFieldStyle(.plain)
                    .autocapitalization(.none)
                    .keyboardType(.URL)
                    .toolbar {
                        Button(role: .destructive
                               , action: submitNewBackendApiUrlString
                               , label: { Text("Generic.Submit") }
                        )
                    }
                    .onChange(of: urlString) { badUrlString = false }
                    .onAppear{ focusedTextField = true }
                    .focused ($focusedTextField)
            }
            .navigationTitle("UserParameters.BackendApiUrl")
            if badUrlString {
                Text("Generic.BadValue")
                    .foregroundStyle(.red)
                    .background(.clear)
            }
            
        }
        
        private func submitNewBackendApiUrlString() {
            if let _ = try? userParameters.setBackendApiUrl(from: urlString) {
                if navigationPath.count > 0 {
                    navigationPath.removeLast()
                }
            } else {
                badUrlString = true
            }
        }
    }
}


#Preview {
    struct Container : View {
        @State var navigationPath = NavigationPath()
        var body: some View {
            NavigationStack(path: $navigationPath) {
                UserParametersView(userParameters: UserParameters(), navigationPath: $navigationPath)
            }
        }
    }
    return Container()
    
}
