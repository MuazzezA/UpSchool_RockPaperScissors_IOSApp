//
//  GameResultViewController.swift
//  HW2-RockPaperScissors
//
//  Created by Muazzez Aydın on 9.07.2023.
//

import UIKit

  
class GameResultViewController: UIViewController {

    var winner: Winner?
    
    @IBOutlet weak var resultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        switch winner{
        case .user:
            resultLabel.text = "You Win!!!"
        case .computer:
            resultLabel.text = "You Lose"
        case .tie:
            resultLabel.text = "Tie"
        case .none:
            resultLabel.text = "We have a problem"
        }
        
    }
    


}
