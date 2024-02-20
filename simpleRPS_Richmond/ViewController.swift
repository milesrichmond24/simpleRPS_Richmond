//
//  ViewController.swift
//  simpleRPS_Richmond
//
//  Created by MILES RICHMOND on 2/13/24.
//

import UIKit
import FirebaseCore
import FirebaseDatabase

class ViewController: UIViewController {
    let reference: DatabaseReference = Database.database().reference()
    
    var currentGameHistory: NSDictionary!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        var currentGame = Game.startGame(gameName: "Game1", players: ["steve", "jobs"])
        
        currentGame.play(.rock, player: "steve")
        currentGame.play(.paper, player: "jobs")
    }
    
    func savePlay(_ play: Play, player: String, round: Int, gameName: String) {
        reference.child(gameName).child("Round: \(round)").child(player).setValue("\(play)")
        reference.child(gameName).child("Round: \(round)").observe(.childAdded, with: { (snapshot) in
            
            
            
            self.reference.child(gameName).child("Round: \(round)").removeAllObservers()
        })
    }
    
    func pullHistory(forGame: String) {
        currentGameHistory = reference.value(forKey: forGame) as! NSDictionary
    }

    func eval(p1: Play, p2: Play) -> Result {
        if(p1 == .rock) {
            if(p2 == .rock) {
                return .tie
            } else if(p2 == .paper) {
                return .lose
            } else if(p2 == .scissors) {
                return .win
            }
        } else if (p1 == .paper) {
            if(p2 == .rock) {
                return .win
            } else if(p2 == .paper) {
                return .tie
            } else if(p2 == .scissors) {
                return .lose
            }
        } else if (p1 == .scissors) {
            if(p2 == .rock) {
                return .lose
            } else if(p2 == .paper) {
                return .win
            } else if(p2 == .scissors) {
                return .tie
            }
        }
        
        return .tie
    }
    
}

/*
struct Game {
    var name: String
    var player1: String
    var player2: String
}
 */

enum Play: CustomStringConvertible {
    case rock
    case paper
    case scissors
    
    var description : String {
        switch self {
        case .rock: return "rock"
        case .paper: return "paper"
        case .scissors: return "scissors"
        }
    }
}
 
enum Result {
    case win
    case lose
    case tie
}
