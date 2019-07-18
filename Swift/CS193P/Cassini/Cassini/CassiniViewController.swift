//
//  CassiniViewController.swift
//  Cassini
//
//  Created by Chen Hanmo on 2019/7/17.
//  Copyright © 2019 Hanmo Chen. All rights reserved.
//

import UIKit

class CassiniViewController: UIViewController {
    //MARK : - navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let identifier = segue.identifier{
            if let url = DemoURLs.NASA[identifier]{
                if let imageVC = segue.destination.contents as? ImageViewController{
                    imageVC.imageURL = url
                    imageVC.title = (sender as? UIButton)?.currentTitle
                }
            }
        }
    }

}

extension UIViewController{
    var contents: UIViewController{
        if let navcon = self as? UINavigationController{
            return navcon.visibleViewController ?? self
        } else {
            return self
        }
    }
}
