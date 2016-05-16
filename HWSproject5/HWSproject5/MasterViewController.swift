//
//  MasterViewController.swift
//  HWSproject5
//
//  Created by Jamaal Sedayao on 5/14/16.
//  Copyright © 2016 Jamaal Sedayao. All rights reserved.
//

import UIKit
import GameplayKit

class MasterViewController: UITableViewController, UITextFieldDelegate {

    var objects = [String]()
    var allWords = [String]()


    override func viewDidLoad() {
        super.viewDidLoad()
        
        uploadFromFile()
        startGame()
        
        //print(objects)
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: #selector(promptForAnswer))
    }
    
    func promptForAnswer() {
        let ac = UIAlertController(title:"Enter Answer", message: nil, preferredStyle: .Alert)
        ac.addTextFieldWithConfigurationHandler(nil)
        
        let submitAction = UIAlertAction(title: "Submit", style: .Default){[unowned self, ac](action:UIAlertAction!) in
            let answer = ac.textFields![0]
            self.submitAnswer(answer.text!)
        }
        ac.addAction(submitAction)
        presentViewController(ac, animated: true, completion: nil)
    }
    
    func submitAnswer(answer: String) {
            let lowerAnswer = answer.lowercaseString
        
            let errorTitle: String
            let errorMessage: String
        
            if wordIsPossible(lowerAnswer) {
                print("pass1")
                if wordIsOriginal(lowerAnswer) {
                    print("pass2")
                    if wordIsReal(lowerAnswer) {
                        
                        objects.append(answer)
                        
                        print(objects)
                        
                        let indexPath = NSIndexPath(forRow: objects.count-1, inSection: 0)
                        tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
                        
                        return
                        
                    } else {
                        errorTitle = "Word not recognised"
                        errorMessage = "You can't just make them up, you know!"
                    }
                } else {
                    errorTitle = "Word used already"
                    errorMessage = "Be more original!"
                }
            } else {
                errorTitle = "Word not possible"
                errorMessage = "You can't spell that word from '\(title!.lowercaseString)'!"
        }
        
        let ac = UIAlertController(title: errorTitle, message: errorMessage, preferredStyle: .Alert)
        ac.addAction(UIAlertAction(title: "OK", style: .Default, handler: nil))
        presentViewController(ac, animated: true, completion: nil)
    }


   func wordIsPossible(word:String)-> Bool {
    
        var tempWord = title!.lowercaseString
        
        for letter in word.characters {
            if let pos = tempWord.rangeOfString(String(letter)) {
                tempWord.removeAtIndex(pos.startIndex)
            } else {
                return false
            }
        }
        return true
    }
    
    func wordIsOriginal(word:String)-> Bool {
        
        return !objects.contains(word)
    }
    
    func wordIsReal(word:String)-> Bool {
        
        let checker = UITextChecker()
        let range = NSMakeRange(0, word.characters.count)
        let misspelledRange = checker.rangeOfMisspelledWordInString(word,
                                                                    range: range,
                                                                    startingAt: 0,
                                                                    wrap: false,
                                                                    language: "en")
        
        return misspelledRange.location == NSNotFound
    }


    
    func uploadFromFile() {
        
        if let startWordsPath = NSBundle.mainBundle().pathForResource("start", ofType: "txt"){
            if let startWords = try? String(contentsOfFile: startWordsPath) {      //try? means "call this code, and if it throws an error just send me back nil instead." This means the code you call will always work, but you need to unwrap the result carefully.
                
                allWords = startWords.componentsSeparatedByString("\n")
            } else {
               allWords = ["silkworm"]
            }
        }
        
    }
    
    func startGame() {
        
        let randomIndex = GKRandomSource.sharedRandom().nextIntWithUpperBound(12383) //grab random index instead
        //allWords = GKRandomSource.sharedRandom().arrayByShufflingObjectsInArray(allWords) as! [String]
        title = allWords[randomIndex]
        objects.removeAll(keepCapacity: true)
        tableView.reloadData()
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object
        return cell
    }

}

