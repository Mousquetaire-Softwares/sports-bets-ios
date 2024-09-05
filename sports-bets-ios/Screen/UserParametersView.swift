//
//  UserParametersView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 03/09/2024.
//

import SwiftUI

struct UserParametersView: View {
    @ObservedObject var userParameters : UserParameters
    @State var backendApiUrlString : String = .empty
    @State var badBackendApiUrlString = false
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
            }
        }
        .navigationDestination(for: Navigation.self) {
            navigation in switch(navigation) {
            case Navigation.backendApiUrlEditor: return backendApiUrlEditor
            }
        }
        .padding()
    }
    
    @ViewBuilder
    private var backendApiUrlEditor : some View {
        VStack(alignment: .leading) {
            Text("UserParameters.BackendApiUrl")
            TextField("Generic.EnterValidURL", text: $backendApiUrlString)
                .onAppear { backendApiUrlString = userParameters.backendApiUrl.absoluteString }
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .autocapitalization(.none)
                .keyboardType(.URL)
                .toolbar {
                    Button(role: .destructive
                           , action: submitNewBackendApiUrlString
                           , label: { Text("Generic.Submit") }
                    )
                }
                .onChange(of: backendApiUrlString) { badBackendApiUrlString = false }
            if badBackendApiUrlString {
                Text("Generic.BadValue")
                    .foregroundStyle(.red)
            }
            Spacer()
        }
        .padding()
        
    }
    
    private func submitNewBackendApiUrlString() {
        if let _ = try? userParameters.setBackendApiUrl(from: backendApiUrlString) {
            if navigationPath.count > 0 {
                navigationPath.removeLast()
            }
        } else {
            badBackendApiUrlString = true
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
