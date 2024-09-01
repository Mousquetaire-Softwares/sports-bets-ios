//
//  sports_bets_iosApp.swift
//  sports-bets-ios
//
//  Created by Steven Morin on 19/08/2024.
//

import SwiftUI
import SwiftData

@main
struct sports_bets_iosApp: App {
    @StateObject var competitionsLibrary = CompetitionsLibrary()
    @StateObject var userLogged = UserLogged()
    
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self,
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(competitionsLibrary)
                .environmentObject(userLogged)
        }
        .modelContainer(sharedModelContainer)
    }
}
