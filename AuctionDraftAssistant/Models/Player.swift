//
//  Player.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import Foundation
import SwiftData

@Model class Player {
    init(firstName: String, lastName: String, position: Position, adp: Double) {
        self.firstName = firstName
        self.lastName = lastName
        self.defenseName = nil
        self.adp = adp
        self.actualCost = nil
        self.team = nil
        self.position = position
    }
    
    init(defenseName: String, adp: Double) {
        self.firstName = nil
        self.lastName = nil
        self.defenseName = defenseName
        self.adp = adp
        self.actualCost = nil
        self.team = nil
        self.position = Position.DEF
    }
    
    var firstName: String?
    var lastName: String?
    var defenseName: String?
    var position: Position
    var adp: Double
    var actualCost: Int?
    
    var team: Team?
}
