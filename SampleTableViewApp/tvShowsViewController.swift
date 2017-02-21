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
    
    var loadMoreIndicator = UIActivityIndicatorView()
    
    let pull2refresh = UIRefreshControl()
    
    var popularTvShows = [[String: String]]()
    
    var topRatedTVShows = [[String: String]]()
    
    var arrOfThumnailsPopular: [UIImage] = []
    var arrOfThumbnailsRated: [UIImage] = []
    
    var currentPagePopular: Int = 1
    var currentPageTopRated: Int = 1
    var totalPagesPopular: Int = -1
    var totalPagesTopRated: Int = -1
    
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
        
        if tvShowTypeSegmentedControl.selectedSegmentIndex == 0 {
            let popularTvShow = popularTvShows[indexPath.row]
            cell.name?.text = popularTvShow["name"]
            cell.overview?.text = popularTvShow["overview"]
            cell.posterImage?.image = arrOfThumnailsPopular[indexPath.row]
        }
        else if tvShowTypeSegmentedControl.selectedSegmentIndex == 1 {
            let topRatedTvShow = topRatedTVShows[indexPath.row]
            cell.name?.text = topRatedTvShow["name"]
            cell.overview?.text = topRatedTvShow["overview"]
            cell.posterImage?.image = arrOfThumbnailsRated[indexPath.row]
        }
        
        return (cell)
        
    }
    
    func getPopularTvShows(page: Int, flag: Int)
    {
        Alamofire.request("https://api.themoviedb.org/3/tv/popular?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=\(page)").responseJSON { response in
            
            if let jsonValue = response.result.value {
                self.totalPagesPopular = JSON(jsonValue)["total_pages"].intValue
                let results = JSON(jsonValue)["results"]
                if results.count > 0 {
                    self.parsePopular(json: results, flag: flag)
                }
            }
        }
    }
    
    func getTopRatedTvShows(page: Int, flag: Int)
    {
        
        Alamofire.request("https://api.themoviedb.org/3/tv/top_rated?api_key=01082f35da875726ce81a65b79c1d08c&language=en-US&page=\(page)").responseJSON { response in
            
            if let jsonValue = response.result.value {
                self.totalPagesTopRated = JSON(jsonValue)["total_pages"].intValue
                let results = JSON(jsonValue)["results"]
                if results.count > 0 {
                    self.parseTopRated(json: results, flag: flag)
                }
            }
        }
    }
    
    func parsePopular(json: JSON, flag: Int)
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
        self.currentPagePopular += 1
        if flag == 0 {
            self.getTopRatedTvShows(page: self.currentPageTopRated, flag: 0)
        }
        else if flag == 1 {
            self.loadMoreIndicator.isHidden = true
            self.loadMoreIndicator.stopAnimating()
            self.tvShowsTableView.reloadData()
        }
        else if flag == 2 {
            self.tvShowsTableView.reloadData()
        }
    }
    
    func parseTopRated(json: JSON, flag: Int)
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
        self.currentPageTopRated += 1
        
        if flag == 0 {
            self.tvShowTypeSegmentedControl.selectedSegmentIndex = 0
            self.tvShowsTableView.reloadData()
        }
        else if flag == 1 {
            self.loadMoreIndicator.isHidden = false
            self.loadMoreIndicator.stopAnimating()
            self.tvShowsTableView.reloadData()
        }
        else if flag == 2 {
            self.tvShowsTableView.reloadData()
        }
    }
    
    func pull2refreshData()
    {
        if self.tvShowTypeSegmentedControl.selectedSegmentIndex == 0 {
            self.popularTvShows.removeAll()
            self.arrOfThumnailsPopular.removeAll()
            self.currentPagePopular = 1
            self.getPopularTvShows(page: self.currentPagePopular, flag: 2)
            self.pull2refresh.endRefreshing()
        } else {
            self.topRatedTVShows.removeAll()
            self.arrOfThumbnailsRated.removeAll()
            self.currentPageTopRated = 1
            self.getTopRatedTvShows(page: self.currentPageTopRated, flag: 2)
            self.pull2refresh.endRefreshing()
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset
        let bounds = scrollView.bounds
        let size = scrollView.contentSize
        let inset = scrollView.contentInset
        let y = CGFloat(offset.y + bounds.size.height - inset.bottom)
        let h = CGFloat(size.height)
        
        let reload_distance = CGFloat(50)
            if(y > (h + reload_distance)) {
                switch self.tvShowTypeSegmentedControl.selectedSegmentIndex {
                case 0:
                    if currentPagePopular <= totalPagesPopular {
                        self.loadMoreIndicator.isHidden = false
                        self.loadMoreIndicator.startAnimating()
                        self.getPopularTvShows(page: self.currentPagePopular, flag: 1)
                    }
                    break
                case 1:
                    if currentPageTopRated <= totalPagesTopRated {
                        self.loadMoreIndicator.isHidden = false
                        self.loadMoreIndicator.startAnimating()
                        self.getTopRatedTvShows(page: self.currentPageTopRated, flag: 1)
                    }
                    break
                default:
                    print("default")
                    break
                }
            }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loader.isHidden = false
        self.loader.startAnimating()
        self.tvShowTypeSegmentedControl.isEnabled = false        
        self.getPopularTvShows(page: self.currentPagePopular, flag: 0)
        self.pull2refresh.addTarget(self, action: #selector(tvShowsViewController.pull2refreshData), for: UIControlEvents.valueChanged)
        self.tvShowsTableView.refreshControl = pull2refresh
        
        //loadMoreIndicator config
        self.loadMoreIndicator.color = UIColor.gray
        self.loadMoreIndicator.hidesWhenStopped = true
        self.loadMoreIndicator.isHidden = true
        self.loadMoreIndicator.frame = CGRect(x: 0, y: 20, width: 20, height: 20)
        self.tvShowsTableView.tableFooterView = loadMoreIndicator
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }      
}
