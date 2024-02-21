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
        if(player != players[playerCurrent]) {
            print("incorrect player")
            return
        }
        
        Game.reference.child(gameName).child("Round: \(round)").child(player).setValue("\(play)")
        
        if(player == players[1]) {
            round += 1
            playerCurrent = 0
        } else if(player == players[0]){
            print("waiting for play")
            waitForPlay(play)
            playerCurrent = 1
        }
    }
    
    func waitForPlay(_ play: Play) {
        Game.reference.child(gameName).child("Round: \(round)").observe(.childAdded, with: { (snapshot) in
            if(snapshot.value as! String == play.description) {
                return
            }
            
            print("other player did thing")
            print(snapshot.value!)
            
            //Game.reference.child(gameName).child("Round: \(round)").child(players[1]).removeAllObservers()
        })
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
        
        return Game(gameName: gameName, players: players)
    }
    
    static func getGame(gameName: String) {
        let playersList = reference.child(gameName).value(forKey: "players") as! NSDictionary
        /*var game = Game(gameName: gameName, players: [playersList["player1"] as! String, playersList["player2"] as! String])
        
        let data = reference.value(forKey: gameName) as! [String : Any]
        
        for i in (0..<data.count - 1) {
            let move = data["Round: \(i / 2)"] as! [String : Play]
            
            if(i % 2 == 0) {
                game.gameHistory.append([])
                game.gameHistory[i].append(move[game.players[0]]!)
            } else {
                game.gameHistory[i - 1].append(move[game.players[1]]!)
            }
        }
        
        game.round = (data.count - 1) / 2
        game.playerCurrent = (data.count - 1) % 2
        */
        
        return
    }
    
    private struct gameData {
        var Round: [[String : String]]
        var players: [String: String]
    }
}
