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

    
    var body: some View {
        NavigationSplitView {
            CompetitionsMenuView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Text(userLogged.user?.firstName ?? .empty)
                        .foregroundColor(Color.blue)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    user
                }
            }
            .navigationTitle("Application.Title")
        } detail: {
            Text("Generic.SelectItem".localized)
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
                    Button("Login.Logout".localized, action: userLogout)
                } label: {
                    Label("Generic.Login".localized, systemImage: "person.fill")
                }
            }
        } else {
            Button(action: showUserLogin) {
                Label("Generic.Login".localized, systemImage: "person")
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
