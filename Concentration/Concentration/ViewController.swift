//
//  ViewController.swift
//  Concentration
//
//  Created by ynoTL on 9/5/19.
//

import UIKit

class ViewController: UIViewController {
    
    // allow VC and Concentration to comm with each other
    // Concentration has a free init() when all vars are init'd
    // structs get free init() too but all vars need to re-init'd
    
    // 'lazy' var does not init before something calls for it
    // 'lazy' cannot have didSet{} / property observers
    private lazy var game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    // game var is only used by VC, set to pvt
    
    private var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }

    // anyone can read this, but only VC can set the value
    private(set) var flipCount = 0 {
        didSet {
            updateFlipCountLabel()
        }
    }
    
    private func updateFlipCountLabel() {
        let attributes : [NSAttributedStringKey : Any] = [
            .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1),
            .strokeWidth: 5
        ]
    
        let attributedString = NSAttributedString(string: "Flips: \(flipCount)", attributes: attributes)
    
        flipCountLabel.attributedText = attributedString
    }
    
    @IBOutlet private weak var flipCountLabel: UILabel! {
        didSet {
            updateFlipCountLabel()
        }
    }

    // var cardbuttons: Array<UIButton>
    @IBOutlet private var cardButtons: [UIButton]!

    // only VC calls this
    @IBAction private func touchedCard(_ sender: UIButton) {
        flipCount += 1
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("Chosen card not found in cardButtons")
        }
    }

    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: UIControlState.normal)
                button.backgroundColor = #colorLiteral(red: 0.9999960065, green: 1, blue: 1, alpha: 1)
            } else {
                button.setTitle("", for: UIControlState.normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 01, green: 0, blue: 0, alpha: 0) : #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }

    }

    private var emojiChoices = "👻🎃☠️😈🍎🧟‍♂️🍬🍫🍭"

    // identifier is an int
    // value is a string
    private var emoji = [Card: String]()
    // var emoji: Dictionary<Int, String>()

    private func emoji(for card: Card) -> String {
        // Dict returns an Optional ==> String?
        // Dictionary may or may not return a string
        
        // if emoji not set and we have emoji choices, put in dict
        if emoji[card] == nil, emojiChoices.count > 0 {
            let randomStringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            // emojiChoices.count.arc4random
            // gen random num from zero to end-value, exclusive
            // arc4rand only works with unsigned ints (UInt32: is a struct as well)
            // you must convert beforehand
            // "arc4random" is associated to/extension of Int, emojiChoise.count will return an int
            let character = emojiChoices.remove(at: randomStringIndex)
            emoji[card] = String(character)
        }

        // returns 'emoji[card.identifier]' but if nil, return "?"
        return emoji[card] ?? "?"
    }

}


// extend Int for arc4random func
extension Int {
    var arc4random: Int {
        // if value > 0, return int
        if (self > 0) {
            return Int(arc4random_uniform(UInt32(self)))
        } else if (self < 0) { // value is negative
            return -Int(arc4random_uniform(UInt32(-self)))
        } else { // value is zero
            return 0
        }
    }
}

