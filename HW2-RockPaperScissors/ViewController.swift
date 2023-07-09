//
//  ViewController.swift
//  HW2-RockPaperScissors
//
//  Created by Muazzez Aydın on 9.07.2023.
//

import UIKit


enum Winner{
    case user, computer, tie
}

enum Game {
    case rock, paper, scissors
    
    init?(rawValue: Int) {
          switch rawValue {
          case 0:
              self = .rock
          case 1:
              self = .paper
          case 2:
              self = .scissors
          default:
              return nil
          }
      }
    
    func winningCondition(opponent: Game) -> Bool {
            switch (self, opponent) {
            case (.rock, .scissors), (.paper, .rock), (.scissors, .paper):
                return true
            default:
                return false
            }
        }
}

struct Score{
    var user:Int = 0
    var computer:Int = 0

    mutating func resetScore() {
            user = 0
            computer = 0
        }
}



class ViewController: UIViewController {
    
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var computerChoice: UIImageView!
    @IBOutlet weak var userScoreLabel: UILabel!
    @IBOutlet weak var computerScoreLabel: UILabel!
    
    let images = ["paper", "rock", "scissors"]
    var selectedButton: UIButton?
    var roundWinner: Winner?
    var score = Score()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.isHidden = true
        rockButton.tag = 0
        paperButton.tag = 1
        scissorsButton.tag = 2
        
        rockButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        paperButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        scissorsButton.addTarget(self, action: #selector(buttonClicked(_:)), for: .touchUpInside)
        
    }
    
  
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        computerChoice.image = UIImage(named: "rock-paper-scissors")
        
        userScoreLabel.text = "Your Score : \(score.user)"
        computerScoreLabel.text = "Computer Score : \(score.computer)"
    
    }

    
    func updateScore(userSelection: Game, computerSelection: Game) {
        if userSelection.winningCondition(opponent: computerSelection) {
            score.user = (score.user) + 1
            roundWinner = .user
        } else if computerSelection.winningCondition(opponent: userSelection) {
            score.computer = (score.computer) + 1
            roundWinner = .computer
        }else {
            roundWinner = .tie
        }
    }
  
    @objc func buttonClicked(_ sender: UIButton) {
        sender.layer.shadowColor = UIColor.black.cgColor
        sender.layer.shadowOpacity = 0.6
        sender.layer.shadowOffset = CGSize(width: 0, height: 2)
        sender.layer.shadowRadius = 12
        
        if let selectedButton = selectedButton, selectedButton != sender {
            selectedButton.layer.shadowColor = nil
            selectedButton.layer.shadowOpacity = 0
            selectedButton.layer.shadowOffset = CGSize.zero
            selectedButton.layer.shadowRadius = 0
        }
        
        selectedButton = sender
    }

    @objc func calculateScore(button: UIButton) {
      
        var userSelection = Game(rawValue: selectedButton?.tag ?? 0)!
        var computerSelection = [Game.rock, Game.paper, Game.scissors].randomElement()!
       
        updateScore(userSelection: userSelection, computerSelection: computerSelection)
    }
        
    @IBAction func resultAct(_ sender: Any) {
        
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        
       calculateScore(button: selectedButton!)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) { [weak self] in
            guard let self = self else { return }
            
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true

            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            if let destinationVC = storyboard.instantiateViewController(withIdentifier: "GameResultViewController") as? GameResultViewController {
                destinationVC.winner = roundWinner
                self.navigationController?.pushViewController(destinationVC, animated: true)
            }
        }
        
    }

}
