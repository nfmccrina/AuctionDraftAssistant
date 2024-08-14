//
//  Team.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import Foundation
import SwiftData

@Model class Team {
    init(name: String) {
        self.name = name
        self.players = nil
    }
    
    var name: String
    var players: [Player]?
}
