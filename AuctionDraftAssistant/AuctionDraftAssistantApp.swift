//
//  AuctionDraftAssistantApp.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import SwiftUI
import SwiftData

@main
struct AuctionDraftAssistantApp: App {
    @State private var showImportComplete: Bool = false
    @State private var showImportError: Bool = false
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Player.self,
            Team.self
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
            ContentView(playerImportService: PlayerImportService(modelContext: ModelContext(sharedModelContainer), onComplete: { showImportComplete = true }, onError: { showImportError = true})) .alert(Text("Import complete."), isPresented: $showImportComplete) {} .alert(Text("Import failed."), isPresented: $showImportError) {}
        }
        .modelContainer(sharedModelContainer)
    }
}
