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
        
        savePlay(.paper, player: "steve", round: 10, gameName: "Baller")
        savePlay(.scissors, player: "jobs", round: 10, gameName: "Baller")
        savePlay(.paper, player: "jobs", round: 11, gameName: "Baller")
        
    }
    
    func savePlay(_ play: Play, player: String, round: Int, gameName: String) {
        reference.child(gameName).child("Round: \(round)").child(player).setValue("\(play)")
        reference.child(gameName).child("Round: \(round)").observe(.childAdded, with: { (snapshot) in
            
            
            
            reference.child(gameName).child("Round: \(round)").removeAllObservers()
        })
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
