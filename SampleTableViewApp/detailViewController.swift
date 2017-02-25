//
//  detailViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/9/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class detailViewController: UIViewController, UIWebViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate {
    
    let loader = UIActivityIndicatorView()
    
    @IBOutlet weak var myScrollView: UIScrollView!
    @IBOutlet weak var backdropImage: UIImageView!
    
    @IBOutlet weak var movieReleasedLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    
    @IBOutlet weak var movieTrailerWebView: UIWebView!
    @IBOutlet weak var movieVotesLabel: UILabel!
    @IBOutlet weak var movieRuntimeLabel: UILabel!
    @IBOutlet weak var bgImagesCollectionView: UICollectionView!
    @IBOutlet weak var castCollectionView: UICollectionView!
    
    @IBOutlet weak var movieOverviewTextView: UITextView!
    
    var passedValue: String = ""
    var movieId: Int = -1
    var imdbId: String = ""
    var movieTrailerID: String = ""
    var arrOfThumnails: [UIImage] = []
    
    var cast: [String] = []
    var castProfilePics: [UIImage] = []
    
    func roundIt(value: Float, step: Float) -> Float {
        let inv = 1.0 / step
        return Float(round(value * inv) / inv)
    }
    
    func loadYouTube(videoID: String) {
        guard
            let youtubeURL = URL(string: "https://www.youtube.com/embed/\(videoID)")
            else { return }
        self.movieTrailerWebView.loadRequest(URLRequest(url: youtubeURL))
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.bgImagesCollectionView.delegate = self
        self.bgImagesCollectionView.dataSource = self
        self.castCollectionView.delegate = self
        self.castCollectionView.dataSource = self
        
        self.movieTrailerWebView.delegate = self
        self.movieTrailerWebView.isHidden = true
        
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
        
        myScrollView.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
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
                
                for item in results["videos"]["results"].arrayValue {
                    if item.count > 0 {
                        if item["type"] == "Trailer" {
                            self.movieTrailerID = item["key"].stringValue
                        }
                        else {
                            self.movieTrailerID = ""
                        }
                    }
                }
                
                //Backdrop images collection view
                if results["images"]["backdrops"].count > 0 {
                    for item in results["images"]["backdrops"].arrayValue {
                        let imageUrl: String = item["file_path"].stringValue
                        let url = URL(string: "https://image.tmdb.org/t/p/w500" + imageUrl)
                        let data = try? Data(contentsOf: url!)
                        self.arrOfThumnails.append(UIImage(data: data!)!)
                    }
                }
                
                //movie cast and images
                if results["credits"]["cast"].count > 0 {
                    for item in results["credits"]["cast"].arrayValue {
                        let name = item["name"].stringValue
                        self.cast.append(name)
                        
                        if item["profile_path"] == JSON.null {
                            self.castProfilePics.append(UIImage(named: "default_profile_pic.png")!)
                        }
                        else {
                            let imageUrl: String = item["profile_path"].stringValue
                            let url = URL(string: "https://image.tmdb.org/t/p/w500" + imageUrl)
                            let data = try? Data(contentsOf: url!)
                            self.castProfilePics.append(UIImage(data: data!)!)
                        }
                    }
                }
                
                //backdrop image
                if self.movieTrailerID == "" {
                    if results["backdrop_path"] != JSON.null {
                        self.backdropImage.isHidden = false
                        let imageUrl: String = results["backdrop_path"].stringValue
                        let url = URL(string: "https://image.tmdb.org/t/p/w500/" + imageUrl)
                        let data = try? Data(contentsOf: url!)
                        self.backdropImage.image = UIImage(data: data!)
                    }
                    else {
                        self.backdropImage.isHidden = true
                        self.movieTrailerWebView.isHidden = true
                        self.movieOverviewTextView.frame = CGRect(x: 0, y: 9, width: self.view.frame.width, height: 168)
                    }
                }
                else {
                    self.backdropImage.isHidden = true
                    self.movieTrailerWebView.isHidden = false
                    DispatchQueue.main.async {
                        self.loadYouTube(videoID: self.movieTrailerID)
                    }
                }
                self.loader.stopAnimating()
                self.bgImagesCollectionView.reloadData()
                self.castCollectionView.reloadData()
            }
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        var count: Int?
        
        if collectionView == self.bgImagesCollectionView {
            count = self.arrOfThumnails.count
        }
        else if collectionView == self.castCollectionView {
            count = self.cast.count
        }
        
        return count!
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.bgImagesCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bgImgCell", for: indexPath as IndexPath) as! bgImgCollectionViewCell
            cell.backdropImageView.image = self.arrOfThumnails[indexPath.row]
            return cell
        }
        else if collectionView == self.castCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "castCell", for: indexPath as IndexPath) as! castCollectionViewCell
            cell.castNameLabel.text = self.cast[indexPath.row]
            cell.castProfilePicImageView.image = self.castProfilePics[indexPath.row]
            return cell
        }
        
        else { preconditionFailure ("unexpected cell type") }
    }
    
    @IBAction func backFromModal(segue: UIStoryboardSegue) {
        print("and we are back")                
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toWebView" {
            let webVC = segue.destination as? customWebViewController            
            webVC?.imdbId = imdbId
        }
        
        if segue.identifier == "toGallery" {
            let item = self.bgImagesCollectionView!.indexPathsForSelectedItems
            let selectedItem = item?.first
            let destinationVC = segue.destination as? UINavigationController
            let galleryVC = destinationVC?.topViewController as? galleryViewController
            galleryVC?.images = self.arrOfThumnails
            galleryVC?.imageIndex = (selectedItem?.row)!
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }            
}
