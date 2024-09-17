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
    @ObservedObject var userLogged : UserLogged
    @Query private var items: [Item]
    @StateObject private var userLogin  = UserLogin()
    @StateObject private var userParameters  = UserParameters()
    @StateObject private var competitionsLibrary : CompetitionsLibrary

    @State private var navigationPath = NavigationPath()
    
    internal init(userLogged: UserLogged) {
        self.userLogged = userLogged
        _competitionsLibrary = StateObject(wrappedValue: CompetitionsLibrary(for: userLogged))
    }
    
    
    
    enum Navigation {
        case userParameters
    }
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            CompetitionsMenuView(competitionsLibrary: competitionsLibrary)
                .environmentObject(userParameters)
                .toolbar(content: toolbarContent)
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
    
    @ToolbarContentBuilder
    func toolbarContent() -> some ToolbarContent {
        ToolbarItem (placement: .topBarLeading) {
            settings
        }
        ToolbarItem(placement: .topBarTrailing) {
            Text(userLogged.user?.username ?? .empty)
                .foregroundColor(Color.blue)
        }
        ToolbarItem(placement: .topBarTrailing) {
            userLoginMenu
        }
    }
    
    @ViewBuilder
    var userLoginMenu : some View {
        if userLogged.isSet {
            Menu {
                Button("Login.Logout", action: userLogout)
            } label: {
                Label("Generic.Login", systemImage: "person.fill")
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
    let userLogged = UserLogged()
    return ContentView(userLogged: userLogged)
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(userLogged)
}

#Preview {
    let userLogged = UserLogged()
    return ContentView(userLogged: userLogged)
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(userLogged)
        .environment(\.locale, Locale(identifier: "fr-FR"))
}
