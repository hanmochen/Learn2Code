//
//  EmojiArtViewController.swift
//  EmojiArt
//
//  Created by Chen Hanmo on 2019/7/19.
//  Copyright © 2019 Hanmo Chen. All rights reserved.
//

import UIKit

class EmojiArtViewController: UIViewController, UIDropInteractionDelegate{

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    
    @IBOutlet weak var dropZone: UIView!{
        didSet{
            dropZone.addInteraction(UIDropInteraction(delegate: self))
        }
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool{
        return session.canLoadObjects(ofClass: NSURL.self) && session.canLoadObjects(ofClass: UIImage.self)
    }
    
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session:  UIDropSession) -> UIDropProposal{
        return UIDropProposal(operation: .copy)
    }
    
    var imageFetcher: ImageFetcher!
    
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession){
        imageFetcher = ImageFetcher(handler: { (url, image) in
            DispatchQueue.main.async {
                self.emojiArtView.backgroundImage = image
            }
        })
        
        session.loadObjects(ofClass: NSURL.self){ nsurls in
            if let url = nsurls.first as? URL{
                self.imageFetcher.fetch(url)
            }
        }
        
        session.loadObjects(ofClass: UIImage.self) { images in
            if let image = images.first as? UIImage{
                self.imageFetcher.backup = image
            }
        }
    }
    
 
    
    @IBOutlet weak var emojiArtView: EmojiArtView!
    

}
