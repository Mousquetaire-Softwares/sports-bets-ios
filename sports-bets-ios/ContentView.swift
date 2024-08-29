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
    @State private var loginSheetPresented = false

    var body: some View {
        NavigationSplitView {
            CompetitionsMenuView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: login) {
                        Label("Generic.Login".localized, systemImage: userLogged.isSet ? "person.fill" : "person")
                    }
                }
            }
            .navigationTitle("Application.Title".localized)
        } detail: {
            Text("Generic.SelectItem".localized)
        }
        .popover(isPresented: $loginSheetPresented) {
            UserLoginView(userLogin: UserLogin(userLogged: userLogged))
        }
        .background()
    }

    private func login() {
        withAnimation {
            loginSheetPresented = true
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
