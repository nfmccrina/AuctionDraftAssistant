//
//  PlayerRowView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/13/24.
//

import SwiftUI
import SwiftData

struct PlayerRowView: View {
    private var player: Player
    @State private var showDraftActionSheet: Bool = false
    @State private var showNoConfiguredTeamsPopover: Bool = false
    @Query() private var teams: [Team]
    
    init(player: Player) {
        self.player = player
    }
    
    @ViewBuilder
    var body: some View {
        HStack {
            Text("\(player.defenseName == nil ? (player.firstName! + " " + player.lastName!) : player.defenseName!)").strikethrough(player.actualCost != nil)
            Spacer()
            Text("\(String(format: "%.2f", player.adp))").strikethrough(player.actualCost != nil)
            
            if (player.actualCost != nil) {
                Text(player.actualCost == nil ? "" : "$\(player.actualCost!)").foregroundStyle(.red)
            }
        }
        .onTapGesture {
            if teams.isEmpty {
                self.showNoConfiguredTeamsPopover = true
                return
            }
            
            if (player.actualCost == nil) {
                self.showDraftActionSheet = true
            }
            else {
                self.player.actualCost = nil
                
                teams.forEach({team in
                    let index = team.players?.firstIndex(where: {p in p.id == self.player.id})
                    if index != nil {
                        team.players?.remove(at:  index!)
                    }
                })
            }
        }
        .sheet(isPresented: $showDraftActionSheet, content: {
            DraftActionSheetView(player: player)
                .padding()
        })
        .popover(isPresented: $showNoConfiguredTeamsPopover, content: {
            Text("No teams are configured.")
        })
    }
}
