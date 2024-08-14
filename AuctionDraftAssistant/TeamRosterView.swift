//
//  TeamRosterView.swift
//  AuctionDraftAssistant
//
//  Created by Nathan McCrina on 8/12/24.
//

import SwiftUI
import SwiftData

struct TeamRosterView: View {
    @Query(sort: \Team.name) var teams: [Team]
    @Query var players: [Player]
    private let team: Team
    
    init(team: Team) {
        self.team = team
    }
    
    @ViewBuilder
    var body: some View {
        if teams.isEmpty {
            Text("No teams configured.")
        } else {
            VStack {
                let currentTeam = teams.first(where: {t in t.id == self.team.id})
                
                if currentTeam == nil {
                    Spacer()
                } else {
                    HStack {
                        VStack(alignment: .leading, spacing: 5) {
                            let currentTeamPlayers = currentTeam!.players ?? []
                            let qb = currentTeamPlayers.filter({p in p.position == Position.QB}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if qb != nil {
                                Text("QB: \(qb!.firstName!) \(qb!.lastName!) - $\(qb!.actualCost!)")
                            } else {
                                Text("QB:")
                            }
                            
                            let rb1 = currentTeamPlayers.filter({p in p.position == Position.RB}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if rb1 != nil {
                                Text("RB: \(rb1!.firstName!) \(rb1!.lastName!) - $\(rb1!.actualCost!)")
                            } else {
                                Text("RB:")
                            }
                            
                            let rb2 = currentTeamPlayers.filter({p in p.position == Position.RB && p.id != rb1?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if rb2 != nil {
                                Text("RB: \(rb2!.firstName!) \(rb2!.lastName!) - $\(rb2!.actualCost!)")
                            } else {
                                Text("RB:")
                            }
                            
                            let wr1 = currentTeamPlayers.filter({p in p.position == Position.WR}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if wr1 != nil {
                                Text("WR: \(wr1!.firstName!) \(wr1!.lastName!) - $\(wr1!.actualCost!)")
                            } else {
                                Text("WR:")
                            }
                            
                            let wr2 = currentTeamPlayers.filter({p in p.position == Position.WR && p.id != wr1?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if wr2 != nil {
                                Text("WR: \(wr2!.firstName!) \(wr2!.lastName!) - $\(wr2!.actualCost!)")
                            } else {
                                Text("WR:")
                            }
                            
                            let te = currentTeamPlayers.filter({p in p.position == Position.TE}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if te != nil {
                                Text("TE: \(te!.firstName!) \(te!.lastName!) - $\(te!.actualCost!)")
                            } else {
                                Text("TE:")
                            }
                            
                            let flex1 = currentTeamPlayers.filter({p in (p.position == Position.RB || p.position == Position.WR || p.position == Position.TE) && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if flex1 != nil {
                                Text("W/R/T: \(flex1!.firstName!) \(flex1!.lastName!) - $\(flex1!.actualCost!)")
                            } else {
                                Text("W/R/T:")
                            }
                            
                            let flex2 = currentTeamPlayers.filter({p in (p.position == Position.RB || p.position == Position.WR || p.position == Position.TE) && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if flex2 != nil {
                                Text("W/R/T: \(flex2!.firstName!) \(flex2!.lastName!) - $\(flex2!.actualCost!)")
                            } else {
                                Text("W/R/T:")
                            }
                            
                            let flex3 = currentTeamPlayers.filter({p in (p.position == Position.RB || p.position == Position.WR || p.position == Position.TE || p.position == Position.QB) && p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if flex3 != nil {
                                Text("W/R/T/Q: \(flex3!.firstName!) \(flex3!.lastName!) - $\(flex3!.actualCost!)")
                            } else {
                                Text("W/R/T/Q:")
                            }
                            
                            let def = currentTeamPlayers.filter({p in p.position == Position.DEF}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if def != nil {
                                Text("DEF: \(def!.defenseName!) - $\(def!.actualCost!)")
                            } else {
                                Text("DEF:")
                            }
                            
                            let bn1 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn1 != nil {
                                Text("BN: \(bn1!.defenseName ?? (bn1!.firstName! + " " + bn1!.lastName!)) - $\(bn1!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                            
                            let bn2 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id && p.id != bn1?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn2 != nil {
                                Text("BN: \(bn2!.defenseName ?? (bn2!.firstName! + " " + bn2!.lastName!)) - $\(bn2!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                            
                            let bn3 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id && p.id != bn1?.id && p.id != bn2?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn3 != nil {
                                Text("BN: \(bn3!.defenseName ?? (bn3!.firstName! + " " + bn3!.lastName!)) - $\(bn3!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                            
                            let bn4 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id && p.id != bn1?.id && p.id != bn2?.id && p.id != bn3?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn4 != nil {
                                Text("BN: \(bn4!.defenseName ?? (bn4!.firstName! + " " + bn4!.lastName!)) - $\(bn4!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                            
                            let bn5 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id && p.id != bn1?.id && p.id != bn2?.id && p.id != bn3?.id && p.id != bn4?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn5 != nil {
                                Text("BN: \(bn5!.defenseName ?? (bn5!.firstName! + " " + bn5!.lastName!)) - $\(bn5!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                            
                            let bn6 = currentTeamPlayers.filter({p in p.id != qb?.id && p.id != rb1?.id && p.id != rb2?.id && p.id != wr1?.id && p.id != wr2?.id && p.id != te?.id && p.id != flex1?.id && p.id != flex2?.id && p.id != flex3?.id && p.id != def?.id && p.id != bn1?.id && p.id != bn2?.id && p.id != bn3?.id && p.id != bn4?.id && p.id != bn5?.id}).sorted(by: {$0.actualCost! > $1.actualCost!}).first
                            
                            if bn6 != nil {
                                Text("BN: \(bn6!.defenseName ?? (bn6!.firstName! + " " + bn6!.lastName!)) - $\(bn6!.actualCost!)")
                            } else {
                                Text("BN:")
                            }
                        }
                        Spacer()
                    }
                }
            }
        }
    }
}
