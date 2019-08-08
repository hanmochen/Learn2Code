//
//  TextFieldCollectionViewCell.swift
//  EmojiArt
//
//  Created by Hanmo Chen on 2019/7/25.
//  Copyright © 2019 Hanmo Chen. All rights reserved.
//

import UIKit

class TextFieldCollectionViewCell: UICollectionViewCell,UITextFieldDelegate {
    
    @IBOutlet weak var textField: UITextField! {
        didSet {
            textField.delegate = self
        }
    }
    
    var resignationHandler: (()-> Void)?
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        resignationHandler?()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
