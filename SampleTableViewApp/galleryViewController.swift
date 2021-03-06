//
//  galleryViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/23/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import SDWebImage

class galleryViewController: UIViewController, UIScrollViewDelegate {

    @IBOutlet weak var galleryNavItem: UINavigationItem!
    @IBOutlet weak var galleryImageView: UIImageView!
    
    @IBOutlet weak var navItem: UINavigationItem!
    @IBOutlet weak var previousBtn: UIBarButtonItem!
    
    @IBOutlet weak var nextBtn: UIBarButtonItem!
    
    @IBOutlet weak var galleryScrollView: UIScrollView!
    
    var imageUrls: [String] = []
    var index: Int = 0
    var imageIndex: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navItem.title = "\(imageIndex) out of \(imageUrls.count - 1)"
        self.galleryImageView.isUserInteractionEnabled = true
        
        self.galleryImageView.setShowActivityIndicator(true)
        self.galleryImageView.setIndicatorStyle(.gray)
        self.galleryImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + imageUrls[imageIndex]))
        
        //Setup scrollview
        galleryScrollView.delegate = self        
        galleryScrollView.alwaysBounceVertical = false
        galleryScrollView.alwaysBounceHorizontal = false
        galleryScrollView.showsVerticalScrollIndicator = true
        galleryScrollView.flashScrollIndicators()
        
        galleryScrollView.minimumZoomScale = 1.0
        galleryScrollView.maximumZoomScale = 10.0
        
        galleryImageView.layer.cornerRadius = 11.0
        galleryImageView.clipsToBounds = false
        
        //Setup swipe gestures
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(galleryViewController.swiped(gesture:)))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.galleryImageView.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(galleryViewController.swiped(gesture:)))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        self.galleryImageView.addGestureRecognizer(swipeLeft)
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.galleryImageView
    }
    
    func swiped(gesture: UIGestureRecognizer) {
        
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
                case UISwipeGestureRecognizerDirection.right:
                    print("swiped right")
                    
                    if imageIndex > 0 {
                        imageIndex -= 1
                    }
                    
                    if imageIndex >= 0 {
                        UIView.animate(withDuration: 0.5, animations: {
                            self.galleryImageView.setShowActivityIndicator(true)
                            self.galleryImageView.setIndicatorStyle(.gray)
                            self.galleryImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + self.imageUrls[self.imageIndex]))
                        })
                        self.navItem.title = "\(imageIndex) out of \(imageUrls.count - 1)"
                    }
                    
                    break
                case UISwipeGestureRecognizerDirection.left:
                    print("swiped left")
                    
                    if imageIndex < imageUrls.count - 1 {
                        imageIndex += 1
                    }
                    
                    if imageIndex < imageUrls.count {
                        self.galleryImageView.setShowActivityIndicator(true)
                        self.galleryImageView.setIndicatorStyle(.gray)
                        self.galleryImageView.sd_setImage(with: URL(string: "https://image.tmdb.org/t/p/w500" + self.imageUrls[self.imageIndex]))
                        self.navItem.title = "\(imageIndex) out of \(imageUrls.count - 1)"
                    }
                    
                    break
                default:
                    break
            }
        }
        
    }
    
    @IBAction func galleryImageViewTap(_ sender: Any) {
        if galleryScrollView.backgroundColor == UIColor.black {
            UIView.animate(withDuration: 0.5) {
                self.galleryScrollView.backgroundColor = UIColor.init(colorLiteralRed: 90/255, green: 90/255, blue: 90/255, alpha: 1.0)
            }
        }
        else {
            UIView.animate(withDuration: 0.5) {
                self.galleryScrollView.backgroundColor = UIColor.black
            }
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
