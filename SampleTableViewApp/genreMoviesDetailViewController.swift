//
//  genreMoviesDetailViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/13/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class genreMoviesDetailViewController: UIViewController {

    @IBOutlet weak var myScrollView: UIScrollView!
    
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var movieReleasedLabel: UILabel!
    
    @IBOutlet weak var movieLanguageLabel: UILabel!
    
    @IBOutlet weak var movieVotesLabel: UILabel!
    
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
    let loader = UIActivityIndicatorView()
    
    var passedValue: String = ""
    var movieId: Int = -1
    var type: IndexPath = []
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
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let webVC = segue.destination as? customWebViewController
            webVC?.imdbId = imdbId
        }
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
