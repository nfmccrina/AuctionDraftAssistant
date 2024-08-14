//
//  DraftActionSheetView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/13/24.
//

import SwiftUI
import SwiftData
import Combine

struct DraftActionSheetView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Query() private var teams: [Team]
    
    @State private var draftPriceInput: String
    @State private var draftingTeam: Team?
    @State private var showInvalidTeamMessage: Bool = false
    
    private let player: Player
    
    init(player: Player) {
        draftPriceInput = ""
        draftingTeam = nil// model.teams.isEmpty ? UUID() : model.teams.sorted(by: {$0.name < $1.name}).first!.id
        self.player = player
    }
    
    var body: some View {
        VStack {
            Form {
                TextField(text: $draftPriceInput, prompt: Text("0")) {
                    Text("Draft Price: $")
                }
                .onReceive(Just(draftPriceInput), perform: { updatedText in
                    let filtered = updatedText.filter({"0123456789".contains($0)})
                    if filtered != updatedText {
                        draftPriceInput = filtered
                        return
                    }
                    
                    if updatedText.count > 2 {
                        draftPriceInput = String(updatedText[..<updatedText.index(updatedText.startIndex, offsetBy: 2)])
                    }
                })
                .frame(minWidth: 115)
                
                Picker("Drafting team:", selection: $draftingTeam) {
                    Text("Select team:").tag(nil as Team?)
                    ForEach(teams.sorted(by: {$0.name < $1.name})) { team in
                        Text(team.name).tag(team as Team?)
                    }
                } .popover(isPresented: $showInvalidTeamMessage, content: {
                    Text("A team must be selected")
                })
            }
            Button(action: {
                if (draftingTeam == nil) {
                    showInvalidTeamMessage = true
                    return
                }
                player.actualCost = Int(draftPriceInput)
                
                teams.first(where: {team in team.id == draftingTeam?.id})?.players?.append(player)
                dismiss()
            }) {
                Text("Save")
            }
        }
    }
}
