//
//  EmojiArtView.swift
//  EmojiArt
//
//  Created by Chen Hanmo on 2019/7/19.
//  Copyright © 2019 Hanmo Chen. All rights reserved.
//

import UIKit

class EmojiArtView: UIView
{

    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    var backgroundImage: UIImage? {
        didSet{
            setNeedsDisplay()
        }
    }
    override func draw(_ rect: CGRect) {
        // Drawing code
        backgroundImage?.draw(in: bounds)
    }
    

}
