//
//  ContentView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import SwiftUI
import SwiftData

let pages = [
        PageInfo(id: 0, name: "Team Management"),
        PageInfo(id: 1, name: "Draft Board"),
    ]

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var selectedPage: Int?
    @State private var showImportConfirmation: Bool = false
    // @Query private var items: [Item]
    
    private let playerImportService: PlayerImporter
    
    init(playerImportService: PlayerImporter) {
        selectedPage = 0
        self.playerImportService = playerImportService
    }

    var body: some View {
        NavigationSplitView {
//            List {
//                ForEach(items) { item in
//                    NavigationLink {
//                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//                    } label: {
//                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
            List(selection: $selectedPage) {
                ForEach(pages) { page in
                    Text(page.name)
                }
            }
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
//            .toolbar {
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
        } detail: {
            if selectedPage == 0 {
                TeamManagementView()
            } else if selectedPage == 1 {
                DraftBoardView()
                    .toolbar {
                        Button(action: {
                            showImportConfirmation = true
                        }) {
                            Text("Import Players")
                        } .confirmationDialog(Text("Importing will replace all currently loaded players. Continue?"), isPresented: $showImportConfirmation) {
                            Button("Import") {
                                playerImportService.importPlayers()
                                
                            }
                        }
                    }
            } else {
                Text("Select a page.")
            }
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(items[index])
//            }
//        }
//    }
}

#Preview {
    ContentView(playerImportService: MockPlayerImportService())
        .modelContainer(for: [Player.self, Team.self], inMemory: true)
}
