//
//  galleryViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/23/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class galleryViewController: UIViewController {

    @IBOutlet weak var galleryNavItem: UINavigationItem!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    @IBOutlet weak var previousBtn: UIBarButtonItem!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    var images: [UIImage] = []
    var index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.galleryImageView.image = self.images[index]
        self.index += 1
        self.galleryNavItem.title = "\(index) out of \(images.count)"
        // Do any additional setup after loading the view.
    }
    
    @IBAction func toPrevious(_ sender: Any) {
        if self.index > 0 || self.index <= self.images.count {
            self.previousBtn.isEnabled = true
            self.galleryImageView.image = self.images[self.index]
            self.galleryNavItem.title = "\(index) out of \(images.count)"
            self.index -= 1
        }
        else {
            self.previousBtn.isEnabled = false
        }
    }
    
    @IBAction func toNext(_ sender: Any) {
        if self.index >= 0 || self.index < self.images.count {
            self.nextBtn.isEnabled = true
            self.galleryImageView.image = self.images[self.index]
            self.galleryNavItem.title = "\(index) out of \(images.count)"
            self.index += 1
        }
        else {
            self.nextBtn.isEnabled = false
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
