//
//  Card.swift
//  Concentration
//
//  Created by Chen Hanmo on 2019/7/8.
//  Copyright © 2019 Chen Hanmo. All rights reserved.
//

import Foundation

struct Card: Hashable
{
    var hashValue: Int {return identifier}
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    static func ==(lhs:Card, rhs: Card)-> Bool{
        return lhs.identifier == rhs.identifier
    }
    var isFaceUp = false
    var isMatched = false
    private var identifier:Int
    
//    static var identifierFactory = 0
//    static func getUniqueIdentifier()->Int{
//        identifierFactory += 1
//        return identifierFactory
//    }

    init(_ identifier: Int) {
        self.identifier = identifier
    }
}



