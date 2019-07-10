//
//  Concentration.swift
//  Concentration
//
//  Created by Chen Hanmo on 2019/7/8.
//  Copyright © 2019 Chen Hanmo. All rights reserved.
//

import Foundation

struct Concentration {
    private(set) var cards  = [Card]()
    
    private var indexOfOneAndOnlyFaceUpCard: Int? {
        get {
             return cards.indices.filter {cards[$0].isFaceUp}.oneAndOnly
        }
        
        set {
            for index in cards.indices{
                cards[index].isFaceUp = (index == newValue)
            }
        }
    }
    mutating func chooseChard(at index:Int) {
        assert(cards.indices.contains(index),"Concentration.chooseCard(at: \(index)): choses index out of range")
        if !cards[index].isMatched{
            if let matchIndex = indexOfOneAndOnlyFaceUpCard, matchIndex != index {
                if cards[matchIndex] == cards[index]{
                    cards[matchIndex].isMatched = true
                    cards[index].isMatched = true
                }
                cards[index].isFaceUp = true
            }else{
                indexOfOneAndOnlyFaceUpCard = index
            }
        }
    }
    
    init(numberOfPairsOfCards: Int){
        assert(numberOfPairsOfCards>0, "Concentration.init(\(numberOfPairsOfCards)): you must have at least one pair of cards")
        var identifiers = [Int](1...numberOfPairsOfCards)
        identifiers += identifiers
        let shuffledIdentifiers = identifiers.shuffled()
        for index in 1...(2*numberOfPairsOfCards) {
            cards.append(Card(shuffledIdentifiers[index-1]))
        }
    }
}

extension Collection {
    var oneAndOnly: Element?{
        return count == 1 ? first : nil
    }
}
