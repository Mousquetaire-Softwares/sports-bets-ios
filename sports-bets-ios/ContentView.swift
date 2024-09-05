//
//  ContentView.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @EnvironmentObject var userLogged : UserLogged
    @Query private var items: [Item]
    @StateObject private var userLogin = UserLogin()
    @StateObject private var userParameters = UserParameters()
    @State private var navigationPath = NavigationPath()
    
    enum Navigation {
        case userParameters
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            CompetitionsMenuView()
            .toolbar {
                ToolbarItem (placement: .topBarLeading) {
                    settings
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Text(userLogged.user?.firstName ?? .empty)
                        .foregroundColor(Color.blue)
                }
                ToolbarItem(placement: .topBarTrailing) {
                    user
                }
            }
            .navigationDestination(for: Navigation.self) {
                navigation in switch(navigation) {
                case .userParameters: UserParametersView(userParameters: userParameters
                                                         , navigationPath: $navigationPath)
                }
            }
            .navigationTitle("Application.Title")
        }
        .popover(isPresented: $userLogin.isPresented) {
            UserLoginView(userLogin: userLogin)
        }
        .background()
    }

    @ViewBuilder
    var user : some View {
        if userLogged.isSet {
            HStack {
                Text(userLogged.user?.firstName ?? .empty)
                Menu {
                    Button("Login.Logout", action: userLogout)
                } label: {
                    Label("Generic.Login", systemImage: "person.fill")
                }
            }
        } else {
            Button(action: showUserLogin) {
                Label("Generic.Login", systemImage: "person")
            }
        }
    }
    private func showUserLogin() {
        withAnimation {
            userLogin.prepare(for: userLogged)
            userLogin.isPresented = true
        }
    }
    private func userLogout() {
        withAnimation {
            userLogged.setUser(nil)
        }
    }
    
    @ViewBuilder
    var settings : some View {
        Button(action: {
            navigationPath.append(Navigation.userParameters)
        }) {
            Label("UserParameters", systemImage: "gear")
        }
    }

}

#Preview {
    let lib = CompetitionsLibrary()
    let userLogged = UserLogged()
    return
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
            .environmentObject(userLogged)
            .environmentObject(lib)
}

#Preview {
    let lib = CompetitionsLibrary()
    let userLogged = UserLogged()
    return
        ContentView()
            .modelContainer(for: Item.self, inMemory: true)
            .environmentObject(lib)
            .environmentObject(userLogged)
            .environment(\.locale, Locale(identifier: "fr-FR"))
}
