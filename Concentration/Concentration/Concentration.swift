//
//  Concentration.swift
//  Concentration
//
//  Created by ynoTL on 9/5/19.
//

import Foundation

struct Concentration {

    // init 'cards' array
    private(set) var cards = [Card]()
    // others can access but not set
    
    
    // return the one and only face up card
    // if there isnt JUST one face up card, return nil
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
            // return all cards in which isFaceUp == True
            return cards.indices.filter { cards[$0].isFaceUp }.oneAndOnly
            
            // ^ ^ ^ ^ ^ using closures
//            var cardFoundIndex : Int?
//            for index in cards.indices {
//                if cards[index].isFaceUp {
//                    if cardFoundIndex == nil {
//                        cardFoundIndex = index
//                    } else {
//                        cardFoundIndex = nil
//                    }
//                }
//            }
//            return cardFoundIndex
        }
        
        // new index of the only card face up
        set(newValue) {
            for index in cards.indices {
                // if index is equal newValue, card at particular will be true
                // else, set false
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }

    // accessed by others
    internal mutating func chooseCard(at index: Int) {
        // error handle
        // check if current index is in 'cards' arrays
        assert(cards.indices.contains(index), "Concentration.chooseCard(at: \(index): chosen index not valid")
        // else, print error statement and crash app
        
        // if card is not matched
        if !cards[index].isMatched {
            // if only one faceup and not the same index
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                // check if cards match
                if cards[matchIndex] == cards[index] {
                    // they match!
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            } else {
                // either no cards or 2 cards are face up
                // so set the only card's index
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }

    init(numberOfPairsOfCards: Int) {
        // error handle, make sure num of cards is valid
        assert(numberOfPairsOfCards > 0, "Concentration.init(\(numberOfPairsOfCards): You must have at least one pair of cards")

        // x..<value ==> range from 0 UP TO end-value
        // x...value ==> range from x to end-value, including end-value
        for _ in 1...numberOfPairsOfCards {
            let card = Card()
            cards += [card, card] // copy cards into array

            // 'card' gets copied over into array 'cards'
            // cards.append(card)
            // cards.append(card)
        }

        // TODO: Shuffle the cards

    }

}

extension Collection {
    var oneAndOnly : Element? {
        // return value if count == 1, else nil
        return count == 1 ? first : nil
    }
    
}

