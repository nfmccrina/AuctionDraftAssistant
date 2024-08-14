//
//  PageInfo.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import Foundation

struct PageInfo: Identifiable {
    init(id: Int, name: String) {
        self.id = id
        self.name = name
    }
    
    let id: Int
    let name: String
}
