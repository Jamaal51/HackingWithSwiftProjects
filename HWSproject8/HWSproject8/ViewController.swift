//
//  ViewController.swift
//  HWSproject8
//
//  Created by Jamaal Sedayao on 5/27/16.
//  Copyright © 2016 Jamaal Sedayao. All rights reserved.
//

import UIKit
import GameplayKit

class ViewController: UIViewController {
    
    var letterButtons = [UIButton]()
    var activatedButtons = [UIButton]()
    var solutions = [String]()
    
    var score: Int = 0 { //property observers, and it lets you execute code whenever a property has changed. Using this method, any time score is changed by anyone, our score label will be updated
        willSet{
            print("Changing score...")
        }
        didSet {
            scoreLabel.text = "Score: \(score)"
            print("score changed")
        }
    }
    
    
    
    var level = 1

    @IBOutlet weak var cluesLabel: UILabel!
    @IBOutlet weak var answersLabel: UILabel!
    @IBOutlet weak var currentAnswer: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //allows us to cleanly give all 20 buttons a target func without dragging any
        for subview in view.subviews where subview.tag == 1001 {  //view.subviews is an array of all subviews
            let btn = subview as! UIButton
            letterButtons.append(btn)
            btn.addTarget(self, action: #selector(letterTapped), forControlEvents: .TouchUpInside)
        }
        
        loadLevel()
    }
    
    func letterTapped(button:UIButton){
        currentAnswer.text = currentAnswer.text! + button.titleLabel!.text!
        activatedButtons.append(button)
        button.hidden = true
    }
    
    private func loadLevel(){
        var clueString = ""
        var solutionString = ""
        var letterBits = [String]()
        
        if let levelFilePath = NSBundle.mainBundle().pathForResource("level\(level)", ofType: "txt"){ //if i can let levelFilePath have access to NSBundle file
            if let levelContents = try? String(contentsOfFile: levelFilePath, usedEncoding: nil){ //and if I can let levelContents be the contents of this file
                var lines = levelContents.componentsSeparatedByString("\n") //returns an array of strings separated by the \n new line
                lines = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(lines) as! [String] //randomizes those lines array
                
                for (index, line) in lines.enumerate(){ //enumerate thru each line. returns index/value position
                    let parts = line.componentsSeparatedByString(": ") //separate the line into two parts and put in array called parts
                    let answer = parts[0]                              //index 0 of new array is answer
                    let clue = parts[1]                                //index 1 of new array is clue
                    
                    clueString += "\(index + 1). \(clue)\n"  //index + 1 because index starts at 0
                    
                    let solutionWord = answer.stringByReplacingOccurrencesOfString("|", withString: "") //takes the split up word and creates a new string by replacing | with ""
                    solutionString += "\(solutionWord.characters.count) letters\n" //takes count of letters
                    solutions.append(solutionWord)
                    
                    let bits = answer.componentsSeparatedByString("|")  //returns array of substrings separated by separator string
                    letterBits += bits
                }
                
            }
            
        }
        
        cluesLabel.text = clueString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        answersLabel.text = solutionString.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        
        letterBits = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterBits) as! [String]
        letterButtons = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(letterButtons) as! [UIButton]
        
        if letterBits.count == letterButtons.count {
            for i in 0 ..< letterBits.count {
                letterButtons[i].setTitle(letterBits[i], forState: .Normal)
            }
        }
        
    }

    @IBAction func submitTapped(sender: UIButton) {
        if let solutionPosition = solutions.indexOf(currentAnswer.text!){ //if my answer is found in solutions array then make solutionPosition the index of that answer
            activatedButtons.removeAll()
            
            var splitClues = answersLabel.text!.componentsSeparatedByString("\n") //split the clues into array of clues
            splitClues[solutionPosition] = currentAnswer.text! //take our current answer and switch that with the clue
            answersLabel.text = splitClues.joinWithSeparator("\n") //rejoin the answerlabel together
            
            currentAnswer.text = "" //turn current answer back to ""
            score += 1
            
        } else {
            if score >= 0 {
            score -= 1
            }
        }
        
        
        if activatedButtons.capacity == 20 {
            let ac = UIAlertController(title: "Nice!", message: "Are you ready for next level?", preferredStyle: .Alert)
            ac.addAction(UIAlertAction(title: "Let's go!", style: .Default, handler: levelUp))
            presentViewController(ac, animated: true, completion: nil)
        }
        
        print(activatedButtons)
    }
    
    func levelUp(action:UIAlertAction!) {
        level += 1
        solutions.removeAll(keepCapacity: true)
        
        loadLevel()
        
        for button in letterButtons {
            button.hidden = false
        }
    }

    @IBAction func clearTapped(sender: UIButton) {
        currentAnswer.text = ""
        
        for button in activatedButtons {
            button.hidden = false
        }
        
        activatedButtons.removeAll()
    }
}

