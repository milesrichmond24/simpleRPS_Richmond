//
//  Game.swift
//  simpleRPS_Richmond
//
//  Created by MILES RICHMOND on 2/16/24.
//

import Foundation
import FirebaseCore
import FirebaseDatabase

struct Game {
    static let reference: DatabaseReference = Database.database().reference()
    let gameName: String
    let players: [String]
    var playerCurrent: Int
    var gameHistory: [[Play]]
    var round: Int
    
    init(gameName: String, players: [String]) {
        self.gameName = gameName
        self.players = players
        self.playerCurrent = 0
        self.round = 0
        self.gameHistory = []
    }
    
    mutating func play(_ play: Play, player: String) {
        if(player == players[playerCurrent]) {
            print("incorrect player")
            return
        }
        
        Game.reference.child(gameName).child("Round: \(round)").child(player).setValue("\(play)")
        
        if(player == players[1]) {
            round += 1
            playerCurrent = 0
        } else {
            playerCurrent = 1
        }
    }
    
    func save() {
        
    }
    
    func evaluateCurrentRound() {
        
    }
    
    static func startGame(gameName: String, players: [String]) -> Game {
        guard (players.count == 2) else {
            return Game(gameName: "Invalid game", players: [])
        }
        
        reference.child(gameName).child("players").child("player1").setValue(players[0])
        reference.child(gameName).child("players").child("player2").setValue(players[1])
        
        return Game(gameName: gameName, players: ["Steve", "Jobs"])
    }
}