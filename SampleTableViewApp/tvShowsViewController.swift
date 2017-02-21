//
//  tvShowsViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/14/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class tvShowsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    @IBOutlet weak var tvShowTypeSegmentedControl: UISegmentedControl!
    
    @IBOutlet weak var tvShowsTableView: UITableView!
    
    let pull2refresh = UIRefreshControl()
    
    var popularTvShows = [[String: String]]()
    
    var topRatedTVShows = [[String: String]]()
    
    var arrOfThumnailsPopular: [UIImage] = []
    var arrOfThumbnailsRated: [UIImage] = []
    
    @IBAction func segmentedValueChanged(_ sender: Any) {
        self.tvShowsTableView.reloadData()
    }
    
    func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the feed; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count: Int = 0
        
        if tvShowTypeSegmentedControl.selectedSegmentIndex == 0 {
            count = popularTvShows.count
        }
        else if tvShowTypeSegmentedControl.selectedSegmentIndex == 1 {
            count = topRatedTVShows.count
        }
        
        return count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tvShowCell", for: indexPath) as! tvShowsTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.posterImage.clipsToBounds = true
        
        let popularTvShow = popularTvShows[indexPath.row]
        let topRatedTvShow = topRatedTVShows[indexPath.row]
        
        if tvShowTypeSegmentedControl.selectedSegmentIndex == 0 {
            cell.name?.text = popularTvShow["name"]
            cell.overview?.text = popularTvShow["overview"]
            cell.posterImage?.image = arrOfThumnailsPopular[indexPath.row]
        }
        else if tvShowTypeSegmentedControl.selectedSegmentIndex == 1 {
            cell.name?.text = topRatedTvShow["name"]
            cell.overview?.text = topRatedTvShow["overview"]
            cell.posterImage?.image = arrOfThumbnailsRated[indexPath.row]
        }
        
        return (cell)
        
    }
    
    func getPopularTvShows()
    {
        Alamofire.request("https://api.themoviedb.org/3/tv/popular?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=1").responseJSON { response in
            
            if let jsonValue = response.result.value {
                let results = JSON(jsonValue)["results"]
                if results.count > 0 {
                    self.parsePopular(json: results)
                }
            }
        }
        
//        let urlString = "https://api.themoviedb.org/3/tv/popular?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=1"
//            if let url = URL(string: urlString) {
//                if let data = try? Data(contentsOf: url) {
//                    let json = JSON(data: data)
//                    
//                    if json["results"].count > 0 {
//                        parsePopular(json: json)
//                        return
//                    }
//                }
//            }
    }
    
    func parsePopular(json: JSON)
    {
        for item in json.arrayValue {
            var thumb = ""
            let name = item["name"].stringValue
            let overview = item["overview"].stringValue
            if item["poster_path"].exists() {
                thumb = item["poster_path"].stringValue
                let url = URL(string: "https://image.tmdb.org/t/p/w185/" + thumb)
                let data = try? Data(contentsOf: url!)
                arrOfThumnailsPopular.append(UIImage(data: data!)!)
            }
            else {
                arrOfThumnailsPopular.append(UIImage(named: "blank_poster_image.jpg")!)
            }
            let showId = item["id"].stringValue
            let obj = ["name": name, "overview": overview, "thumb": thumb, "showId": showId]
            popularTvShows.append(obj)
        }
        self.getTopRatedTvShows()
    }
    
    func parseTopRated(json: JSON)
    {
        for item in json.arrayValue {
            var thumb = ""
            let name = item["name"].stringValue
            let overview = item["overview"].stringValue
            if item["poster_path"].exists() {
                thumb = item["poster_path"].stringValue
                let url = URL(string: "https://image.tmdb.org/t/p/w185/" + thumb)
                let data = try? Data(contentsOf: url!)
                arrOfThumbnailsRated.append(UIImage(data: data!)!)
            }
            else {
                arrOfThumbnailsRated.append(UIImage(named: "blank_poster_image.jpg")!)
            }
            let showId = item["id"].stringValue
            let obj = ["name": name, "overview": overview, "thumb": thumb, "showId": showId]
            topRatedTVShows.append(obj)
        }
        self.loader.stopAnimating()
        self.tvShowTypeSegmentedControl.isEnabled = true
        if self.tvShowTypeSegmentedControl.selectedSegmentIndex != 0 && self.tvShowTypeSegmentedControl.selectedSegmentIndex != 1 {
            self.tvShowTypeSegmentedControl.selectedSegmentIndex = 0
        }
        self.tvShowsTableView.reloadData()
    }
    
    func getTopRatedTvShows()
    {
        
        Alamofire.request("https://api.themoviedb.org/3/tv/top_rated?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=1").responseJSON { response in
            
            if let jsonValue = response.result.value {
                let results = JSON(jsonValue)["results"]
                if results.count > 0 {
                    self.parseTopRated(json: results)
                }
            }
        }
        
//        let urlString = "https://api.themoviedb.org/3/tv/top_rated?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=1"
//        if let url = URL(string: urlString) {
//            if let data = try? Data(contentsOf: url) {
//                let json = JSON(data: data)
//                
//                if json["results"].count > 0 {
//                    parseTopRated(json: json)
//                    return
//                }
//            }
//        }
    }
    
    func pull2refreshData()
    {
        if self.tvShowTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.popularTvShows.removeAll()
            self.arrOfThumnailsPopular.removeAll()
            self.getPopularTvShows()
            self.pull2refresh.endRefreshing()
        } else {
            self.topRatedTVShows.removeAll()
            self.arrOfThumbnailsRated.removeAll()
            self.getTopRatedTvShows()
            self.pull2refresh.endRefreshing()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = false
        self.loader.startAnimating()
        self.tvShowTypeSegmentedControl.isEnabled = false
        self.getPopularTvShows()
        self.pull2refresh.addTarget(self, action: #selector(tvShowsViewController.pull2refreshData), for: UIControlEvents.valueChanged)
        self.tvShowsTableView.refreshControl = pull2refresh
//        let queue = DispatchQueue(label: "make_api_call", attributes: .concurrent, target: .main)
//        
//        let group = DispatchGroup()
//        group.enter()
//        queue.async(group: group) {
//            self.getPopularTvShows()
//            group.leave()
//        }
//        
//        group.enter()
//        queue.async(group: group) {
//            self.getTopRatedTvShows()
//            group.leave()
//        }
//        
//        group.notify(queue: DispatchQueue.main) {
//            if self.popularTvShows.count > 0 && self.topRatedTVShows.count > 0 {
//                self.loader.stopAnimating()
//                self.tvShowTypeSegmentedControl.isEnabled = true
//                self.tvShowTypeSegmentedControl.selectedSegmentIndex = 0
//                self.tvShowsTableView.reloadData()
//            }
//        }
        
        // Do any additional setup after loading the view.
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
