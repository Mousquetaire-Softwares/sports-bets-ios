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
    @Query private var items: [Item]
    @State private var loginSheetPresented = false

    var body: some View {
        NavigationSplitView {
            CompetitionsMenuView()
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: login) {
                        Label("Generic.Login".localized, systemImage: "person")
                    }
                }
            }
            .navigationTitle("Application.Title".localized)
        } detail: {
            Text("Generic.SelectItem".localized)
        }
        .popover(isPresented: $loginSheetPresented) {
            UserLoginView(userLogin: UserLogin())
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
    return ContentView()
        .modelContainer(for: Item.self, inMemory: true)
        .environmentObject(lib)
}
