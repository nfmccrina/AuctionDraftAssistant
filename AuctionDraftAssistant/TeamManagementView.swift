//
//  TeamManagementView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import SwiftUI
import SwiftData

struct TeamManagementView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Team.name) var teams: [Team]
    
    @State private var selectedTeams: [Team?] = []
    
    var body: some View {
        NavigationStack(path: $selectedTeams) {
            List {
                ForEach(teams) { team in
                    NavigationLink(team.name, value: team)
                } .onDelete {
                    $0.forEach {
                        teams[$0].players?.forEach() { player in
                            player.actualCost = nil
                        }
                        
                        modelContext.delete(teams[$0])
                    }
                }
            }
            .navigationDestination(for: Team?.self) { team in
                TeamDetailsView(team: team, path: $selectedTeams).padding()
            }
            .navigationDestination(for: Team.self) { team in
                TeamDetailsView(team: team, path: $selectedTeams).padding()
            }
            .toolbar {
                Button(action: {
                    selectedTeams.append(nil)
                }) {
                    Text("Add")
                }
            }
        }
    }
}
