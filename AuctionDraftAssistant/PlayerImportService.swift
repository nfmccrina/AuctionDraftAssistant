//
//  PlayerImportService.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/13/24.
//

import Foundation
import SwiftUI
import SwiftSoup
import SwiftData
import Combine

protocol PlayerImporter {
    func importPlayers() -> Void
}

class PlayerImportService: PlayerImporter {
    private var teamsFetchDescriptor = FetchDescriptor<Team>()
    private var successCount: Int
    private let onComplete: () -> Void
    private let onError: () -> Void
    
    init(modelContext: ModelContext, onComplete: @escaping () -> Void = {}, onError: @escaping () -> Void = {}) {
        self.modelContext = modelContext
        self.teamsFetchDescriptor = FetchDescriptor<Team>()
        self.successCount = 0
        self.onComplete = onComplete
        self.onError = onError
    }
    
    func importPlayers() {
        self.successCount = 0
        do {
            let qb_url = URL(string: "https://www.fantasypros.com/nfl/adp/qb.php")
            let rb_url = URL(string: "https://www.fantasypros.com/nfl/adp/half-point-ppr-rb.php")
            let wr_url = URL(string: "https://www.fantasypros.com/nfl/adp/half-point-ppr-wr.php")
            let te_url = URL(string: "https://www.fantasypros.com/nfl/adp/half-point-ppr-te.php")
            let def_url = URL(string: "https://www.fantasypros.com/nfl/adp/dst.php")
            
            
            let teams = try self.modelContext.fetch(self.teamsFetchDescriptor)
            
            for team in teams {
                team.players?.removeAll()
            }
            
            try modelContext.delete(model: Player.self)
            
            let qbTask = doImport(url: qb_url!, parser: self.parseQBRow)
            let rbTask = doImport(url: rb_url!, parser: self.parseRBRow)
            let wrTask = doImport(url: wr_url!, parser: self.parseWRRow)
            let teTask = doImport(url: te_url!, parser: self.parseTERow)
            let defTask = doImport(url: def_url!, parser: self.parseDEFRow)
            
            qbTask.resume()
            rbTask.resume()
            wrTask.resume()
            teTask.resume()
            defTask.resume()
            
        } catch {
            print(error)
            onError()
            return
        }
    }
    
    private func doImport(url: URL, parser: @escaping (Element) -> Player?) -> URLSessionDataTask {
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            do {
                guard let html = data else { return }
                
                let doc: Document? = try? SwiftSoup.parse(String(data: html, encoding: .utf8) ?? "")
                let dataTable = try? doc?.getElementById("data")
                let dataTableBody = try dataTable?.getElementsByTag("tbody").first()
                let rows = try? dataTableBody?.getElementsByTag("tr")
                
                if rows == nil {
                    return
                }
                
                for row in rows! {
                    let p = parser(row)
                    
                    if p != nil {
                        self.modelContext.insert(p!)
                    }
                }
                
                self.successCount = self.successCount + 1
                
                if self.successCount == 5 {
                    self.successCount = 0
                    self.onComplete()
                }
            } catch {
                print(error)
                self.onError()
                return
            }
        }
        
        return task
    }
    
    func parseNonDefenseRow(rowElement: Element, position: Position) -> Player? {
        var nameParts = try? rowElement.child(2).getElementsByTag("a").first()?.attr("fp-player-name").split(separator: " ") ?? []
        
        if nameParts == nil || nameParts!.count < 2 {
            return nil
        }
        
        let firstName = String(nameParts!.removeFirst())
        let lastName = nameParts!.joined(separator: " ")
        let adp = try? Double(rowElement.children().last()?.text() ?? "0.0")
        
        if adp == nil {
            return nil
        }
        
        return Player(firstName: firstName, lastName: lastName, position: position, adp: adp!)
    }
    
    func parseQBRow(rowElement: Element) -> Player? {
        return parseNonDefenseRow(rowElement: rowElement, position: Position.QB)
    }
    
    private func parseRBRow(rowElement: Element) -> Player? {
        return parseNonDefenseRow(rowElement: rowElement, position: Position.RB)
    }
    
    private func parseWRRow(rowElement: Element) -> Player? {
        return parseNonDefenseRow(rowElement: rowElement, position: Position.WR)
    }
    
    private func parseTERow(rowElement: Element) -> Player? {
        return parseNonDefenseRow(rowElement: rowElement, position: Position.TE)
    }
    
    private func parseDEFRow(rowElement: Element) -> Player? {
        let name = try? rowElement.child(2).getElementsByTag("a").first()?.attr("fp-player-name")
        
        if name == nil {
            return nil
        }
        
        let adp = try? Double(rowElement.children().last()?.text() ?? "0.0")
        
        if adp == nil {
            return nil
        }
        
        return Player(defenseName: name!, adp: adp!)
    }
    
    private let modelContext: ModelContext
}

class MockPlayerImportService: PlayerImporter {
    func importPlayers() {}
}
