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
        
        Alamofire.request("https://api.themoviedb.org/3/movie/\(self.movieId)?api_key=01082f35da875726ce81a65b79c1d08c").responseJSON { response in
            
            if let jsonValue = response.result.value {
                let results = JSON(jsonValue)
                self.imdbId = results["imdb_id"].stringValue
                self.movieReleasedLabel.text = "Released on " + results["release_date"].stringValue
                self.movieLanguageLabel.text = "Language - " + results["original_language"].stringValue
                self.movieVotesLabel.text = "Vote average - " + results["average_vote"].stringValue
                self.movieRuntimeLabel.text = "Runtime - " + results["runtime"].stringValue
                self.movieOverviewTextView.text = results["overview"].stringValue
                
                let imageUrl: String = results["backdrop_path"].stringValue
                let url = URL(string: "https://image.tmdb.org/t/p/w500/" + imageUrl)
                let data = try? Data(contentsOf: url!)
                self.backdropImage.image = UIImage(data: data!)
                
                self.loader.stopAnimating()
            }
        }
        
//        DispatchQueue.main.async {
//            let url = URL(string:"https://api.themoviedb.org/3/movie/\(self.movieId)?api_key=01082f35da875726ce81a65b79c1d08c")
//            do {
//                let moviesData = try Data(contentsOf: url!)
//                let movieData = try JSONSerialization.jsonObject(with: moviesData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
//                
//                self.imdbId = movieData["imdb_id"] as! String
//                self.movieReleasedLabel.text = "Released on " + (movieData["release_date"] as! String?)!
//                self.movieLanguageLabel.text = "Language - " + (movieData["original_language"] as! String?)!
//                self.movieOverviewTextView.text = movieData["overview"] as! String?
//                
//                let imageUrl: String = (movieData["backdrop_path"] as! String?)!
//                
//                let url = URL(string: "https://image.tmdb.org/t/p/w500/" + imageUrl)
//                let data = try? Data(contentsOf: url!)
//                self.backdropImage.image = UIImage(data: data!)
//                if movieData.count > 0 {
//                    self.loader.stopAnimating()
//                }
//            }
//            catch {
//                
//            }
//        }
        
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
