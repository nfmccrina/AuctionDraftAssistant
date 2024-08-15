//
//  DraftBoardView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/13/24.
//

import SwiftUI
import SwiftData

struct DraftBoardView: View {
    @Query() private var players: [Player]
    @Binding var searchText: String
    private let evenColor: Color = Color(red: 0.2, green: 0.25, blue: 0.25)
    private let oddColor: Color = Color(red: 0.05, green: 0.1, blue: 0.1)

    @ViewBuilder
    var body: some View {
        if players.isEmpty {
            Text("Player data is not loaded.")
        } else {
            HStack {
                VStack {
                    Text("QB")
                    Divider()
                    HStack {
                        Text("Name").padding(.leading, 25)
                        Spacer()
                        Text("ADP").padding(.trailing, 25)
                    }
                    List {
                        ForEach(Array(zip(players.filter({player in
                            player.position == Position.QB && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}).indices, players.filter({player in
                            player.position == Position.QB && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}))), id: \.0) { i, player in
                            PlayerRowView(player: player).listRowBackground(((i / 6) % 2) == 0 ? self.evenColor : self.oddColor)
                        }
                    }
                }
                Divider()
                VStack {
                    Text("WR")
                    Divider()
                    HStack {
                        Text("Name").padding(.leading, 25)
                        Spacer()
                        Text("ADP").padding(.trailing, 25)
                    }
                    List {
                        ForEach(Array(zip(players.filter({player in
                            player.position == Position.WR && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}).indices, players.filter({player in
                            player.position == Position.WR && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}))), id: \.0) { i, player in
                            PlayerRowView(player: player).listRowBackground(((i / 6) % 2) == 0 ? self.evenColor : self.oddColor)
                        }
                    }
                }
                Divider()
                VStack {
                    Text("RB")
                    Divider()
                    HStack {
                        Text("Name").padding(.leading, 25)
                        Spacer()
                        Text("ADP").padding(.trailing, 25)
                    }
                    List {
                        ForEach(Array(zip(players.filter({player in
                            player.position == Position.RB && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}).indices, players.filter({player in
                            player.position == Position.RB && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}))), id: \.0) { i, player in
                            PlayerRowView(player: player).listRowBackground(((i / 6) % 2) == 0 ? self.evenColor : self.oddColor)
                        }
                    }
                }
                Divider()
                VStack {
                    Text("TE")
                    Divider()
                    HStack {
                        Text("Name").padding(.leading, 25)
                        Spacer()
                        Text("ADP").padding(.trailing, 25)
                    }
                    List {
                        ForEach(Array(zip(players.filter({player in
                            player.position == Position.TE && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}).indices, players.filter({player in
                            player.position == Position.TE && (searchText.isEmpty || player.firstName!.lowercased().contains(searchText.lowercased()) || player.lastName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}))), id: \.0) { i, player in
                            PlayerRowView(player: player).listRowBackground(((i / 6) % 2) == 0 ? self.evenColor : self.oddColor)
                        }
                    }
                }
                Divider()
                VStack {
                    Text("DEF")
                    Divider()
                    HStack {
                        Text("Name").padding(.leading, 25)
                        Spacer()
                        Text("ADP").padding(.trailing, 25)
                    }
                    List {
                        ForEach(Array(zip(players.filter({player in
                            player.position == Position.DEF && (searchText.isEmpty || player.defenseName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}).indices, players.filter({player in
                            player.position == Position.DEF && (searchText.isEmpty || player.defenseName!.lowercased().contains(searchText.lowercased()))
                        }).sorted(by: {$0.adp < $1.adp}))), id: \.0) { i, player in
                            PlayerRowView(player: player).listRowBackground(((i / 6) % 2) == 0 ? self.evenColor : self.oddColor)
                        }
                    }
                }
            }
        }
    }
}
