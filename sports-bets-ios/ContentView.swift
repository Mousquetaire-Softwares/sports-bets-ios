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
    @State private var userLoginIsPresented = false
    @StateObject private var userLogin = UserLogin()

//    init(userLogged : UserLogged) {
//        self.userLogged = userLogged
////        self.userLogin = UserLogin(userLogged: userLogged)
//    }
    
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
            .navigationTitle("Application.Title".localized)
        } detail: {
            Text("Generic.SelectItem".localized)
        }
        .popover(isPresented: $userLoginIsPresented) {
            UserLoginView(userLogin: userLogin)
//            UserLoginView(userLogin: userLogin)
        }
        .background()
    }

    @ViewBuilder
    var user : some View {
        if userLogged.isSet {
            HStack {
                Text(userLogged.user?.firstName ?? .empty)
                Button(action: showUserLogin) {
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
            userLoginIsPresented = true
        }
    }
}

#Preview {
    let lib = CompetitionsLibrary()
    let userLogged = UserLogged()
    return ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(lib)
        .environmentObject(userLogged)
}
