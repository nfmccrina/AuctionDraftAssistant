//
//  TeamEditView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import SwiftUI

struct TeamDetailsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var name: String = ""
    @State private var editMode: Bool = false
    @FocusState private var nameIsFocused: Bool
    
    let team: Team?
    private let totalBudget: Int = 200
    
    private var remainingBudget: Int {
        if team?.players == nil {
            return totalBudget
        }
        
        return totalBudget - team!.players!.map({player in player.actualCost}).reduce(0, {total, current in total + current!})
    }
    
    private var maxBid: Int {
        return remainingBudget - (15 - (team?.players?.count ?? 0))
    }
    
    private var path: Binding<[Team?]>
    
    init(team: Team?, path: Binding<[Team?]>) {
        self.editMode = team == nil
        self.team = team
        self.path = path
    }
    
    private var editorTitle: String {
        team == nil ? "Add Team" : (editMode ? "Edit Team" : "Team Details")
    }
    
    @ViewBuilder
    var body: some View {
        VStack {
            if team == nil || editMode {
                Form {
                    VStack {
                        HStack {
                            TextField("Name", text: $name).frame(minWidth: 250).focused($nameIsFocused)
                            Spacer().layoutPriority(1)
                        }
                        HStack {
                            Button("Save") {
                                withAnimation {
                                    save()
                                    dismiss()
                                }
                            }/*.focusable(interactions: .activate)*/
                            Button("Cancel", role: .cancel) {
                                dismiss()
                            }/*.focusable(interactions: .activate)*/
                            Spacer()
                        }
                    }
                    Spacer()
                } .onAppear {
                    if let team {
                        name = team.name
                    }
                    nameIsFocused = true
                }
            } else {
                HStack {
                    Text(team!.name)
                    Button(action: { editMode = true }) {
                        Text("Edit")
                    }
                }
                Divider()
                ScrollView {
                    TeamRosterView(team: team!)
                }
                Divider()
                HStack {
                    Text("Total Budget: $\(totalBudget)")
                    Spacer()
                    Text("Remaining Budget: $\(remainingBudget)").foregroundStyle(maxBid > 5 ? .green : .red)
                    Spacer()
                    Text("Max Bid: $\(maxBid)").foregroundStyle(maxBid > 5 ? .green : .red)
                }.padding(.top)
                Spacer()
            }
        } .toolbar {
            ToolbarItem(placement: .principal) {
                Text(editorTitle)
            }
        }
    }
    
    private func save() {
        if let team {
            team.name = name
        } else {
            let newTeam = Team(name: name)
            modelContext.insert(newTeam)
        }
    }
    
    private func dismiss() {
        editMode = false
        
        if path.wrappedValue.contains(nil) {
            path.wrappedValue.removeAll()
        }
    }
}
