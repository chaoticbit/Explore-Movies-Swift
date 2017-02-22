//
//  detailViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/9/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class detailViewController: UIViewController {
    
    let loader = UIActivityIndicatorView()
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var movieReleasedLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    
    @IBOutlet weak var movieVotesLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    
//    @IBOutlet weak var movieOverviewLabel: UILabel!
    @IBOutlet weak var movieOverviewTextView: UITextView!
    var passedValue: String = ""
    var movieId: Int = -1
    var imdbId: String = ""
    
    func roundIt(value: Float, step: Float) -> Float {
        let inv = 1.0 / step
        return Float(round(value * inv) / inv)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.loader.isHidden = false
        self.loader.hidesWhenStopped = true
        self.loader.backgroundColor = UIColor.white
        self.loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        self.title = passedValue        
        self.automaticallyAdjustsScrollViewInsets = true        
        movieOverviewTextView.backgroundColor = UIColor.clear
        movieOverviewTextView.textAlignment = NSTextAlignment.justified
        
        myScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 650)
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(self.movieId)?api_key=01082f35da875726ce81a65b79c1d08c&append_to_response=reviews,credits,videos,images").responseJSON { response in
            
            if let jsonValue = response.result.value {
                let results = JSON(jsonValue)
                self.imdbId = results["imdb_id"].stringValue
                self.movieReleasedLabel.text = "Released on " + results["release_date"].stringValue
                self.movieLanguageLabel.text = results["original_language"].stringValue.uppercased()
                self.movieRuntimeLabel.text = results["runtime"].stringValue + " mins"
                self.movieOverviewTextView.text = results["overview"].stringValue                
                
                //Iterate ratings
                let starFilled = UIImage(named: "star_filled")
                let starHalf = UIImage(named: "star_half")
                let rating = self.roundIt(value: results["vote_average"].floatValue/2, step: 0.5)
                let incrementer = 20
                let start = 265
                
                if rating.truncatingRemainder(dividingBy: 1) == 0 {
                    let ratingInt = Int(rating)
                    for i in 0..<ratingInt {
                        let imageView: UIImageView = UIImageView(image: starFilled)
                        imageView.frame = CGRect(x: start + (i * incrementer), y: -23, width: 20, height: 20)
                        self.myScrollView.addSubview(imageView)
                    }
                }
                else {
                    let rnd: Int = Int(rating - 0.5)
                    var lastPlace: Int = 0
                    for i in 0..<rnd {
                        let imageView: UIImageView = UIImageView(image: starFilled)
                        imageView.frame = CGRect(x: start + (i * incrementer), y: -23, width: 20, height: 20)
                        lastPlace = start + (i * incrementer)
                        self.myScrollView.addSubview(imageView)
                    }
                    let imageViewHalf: UIImageView = UIImageView(image: starHalf)
                    imageViewHalf.frame = CGRect(x: lastPlace + incrementer, y: -23, width: 20, height: 20)
                    self.myScrollView.addSubview(imageViewHalf)
                }
                
                //backdrop image
                if results["backdrop_path"] != JSON.null {
                    let imageUrl: String = results["backdrop_path"].stringValue
                    let url = URL(string: "https://image.tmdb.org/t/p/w500/" + imageUrl)
                    let data = try? Data(contentsOf: url!)
                    self.backdropImage.image = UIImage(data: data!)
                }
                self.loader.stopAnimating()
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let webVC = segue.destination as? customWebViewController            
            webVC?.imdbId = imdbId
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }            
}
