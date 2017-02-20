//
//  ViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/9/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    let loadMoreActivityIndicator = UIActivityIndicatorView()
    let loader = UIActivityIndicatorView()
    let refreshControl = UIRefreshControl()
    
    let loadMoreView = UIView()
    
    let queue1 = DispatchQueue(label: "load_more")
    
    var upcomingMovies = [[String: String]]()
    var totalPages: Int = 0
    var arrOfThumnails: [UIImage] = []
    var currentPage:Int = 1
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return upcomingMovies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let upcomingMovie = upcomingMovies[indexPath.row]
        print("You selected name : " + upcomingMovie["title"]!)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.posterImage.clipsToBounds = true
        
            let upcomingMovie = upcomingMovies[indexPath.row]
        
            cell.name?.text = upcomingMovie["title"]
            cell.nationality?.text = upcomingMovie["overview"]
        
            DispatchQueue.main.async {
                cell.posterImage?.image = self.arrOfThumnails[indexPath.row]
            }
        
            return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let row = self.myTableView.indexPathForSelectedRow?.row
            let detailVC = segue.destination as? detailViewController
            let upcomingMovie = upcomingMovies[row!]
            detailVC?.passedValue = upcomingMovie["title"]!
            detailVC?.movieId = JSON(upcomingMovie["movieId"]!).intValue
        }
    }
        
    func loadMore(_ button: UIButton)
    {        
        self.loadMoreActivityIndicator.isHidden = false
        self.loadMoreActivityIndicator.startAnimating()
        if currentPage <= totalPages {
            self.getUpcomingMovies(page: self.currentPage, flag: 1)
        }
    }
    
    func scrollToNewRow()
    {
        let count = self.upcomingMovies.count
        var indexPath = [NSIndexPath]()
        for row in count - 20 ..< count {
            indexPath.append(NSIndexPath(row: row, section: 0))
        }
        
        self.myTableView.insertRows(at: indexPath as [IndexPath], with: UITableViewRowAnimation.none)
        self.myTableView.reloadData()
        self.loadMoreActivityIndicator.stopAnimating()
        self.myTableView.scrollToRow(at: indexPath.first! as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    func getUpcomingMovies(page: Int, flag: Int) {                
        
        Alamofire.request("https://api.themoviedb.org/3/movie/upcoming?api_key=01082f35da875726ce81a65b79c1d08c&page=\(page)").responseJSON { response in
            
            if let jsonValue = response.result.value {
                self.totalPages = JSON(jsonValue)["total_pages"].intValue
                let results = JSON(jsonValue)["results"]
                if results.count > 0 {
                    for item in results.arrayValue {
                        var thumb = ""
                        let title = item["title"].stringValue
                        let overview = item["overview"].stringValue
                        if item["poster_path"].exists() {
                            thumb = item["poster_path"].stringValue
                            let url = URL(string: "https://image.tmdb.org/t/p/w185/" + thumb)
                            let data = try? Data(contentsOf: url!)
                            self.arrOfThumnails.append(UIImage(data: data!)!)
                        }
                        else {
                            self.arrOfThumnails.append(UIImage(named: "blank_poster_image.jpg")!)
                        }
                        let movieId = item["id"].stringValue
                        let obj = ["title": title, "overview": overview, "thumb": thumb, "movieId": movieId]
                        self.upcomingMovies.append(obj)

                    }
                    if(flag == 1) {
                        self.scrollToNewRow()
                    }
                    self.currentPage += 1
                    print("current page after incrementing: ", self.currentPage)
                    self.loader.stopAnimating()
                    self.myTableView.reloadData()
                    self.loadMoreView.isHidden = false
                    return
                }
            }
        }
    }
    
    func pullToRefreshData()
    {
        self.upcomingMovies.removeAll()
        self.currentPage = 1
        self.getUpcomingMovies(page: self.currentPage, flag: 0)
        self.refreshControl.endRefreshing()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theHeight = view.frame.size.height //grabs the height of your view
        self.myTableView.refreshControl = refreshControl
        self.loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.loader.isHidden = false
        self.loader.hidesWhenStopped = true
        self.loader.backgroundColor = UIColor.white
        self.loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()
        
        refreshControl.addTarget(self, action: #selector(ViewController.pullToRefreshData), for: UIControlEvents.valueChanged)
        
        //Create a footer UI View
        loadMoreView.isHidden = true
        loadMoreView.backgroundColor = UIColor.white
        loadMoreView.alpha = 1
        loadMoreView.frame = CGRect(x: 0, y: theHeight - 99 , width: self.view.frame.width, height: 50)
        
        //Create a load more UIButton
        let loadMoreBtn = UIButton(frame: CGRect(x: 131, y: 5, width: 100, height: 36))
        loadMoreBtn.setTitle("Load more", for: .normal)
        loadMoreBtn.setTitleColor(UIColor.init(colorLiteralRed: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0), for: .normal)
        loadMoreBtn.titleLabel?.textAlignment = NSTextAlignment.center
        loadMoreBtn.alpha = 1
        loadMoreBtn.isHidden = false
        loadMoreBtn.addTarget(self, action: #selector(genreMoviesViewController.loadMore(_:)), for: UIControlEvents.touchUpInside)
        
        //Create an activity indicator
        loadMoreActivityIndicator.isHidden = true
        loadMoreActivityIndicator.hidesWhenStopped = true
        loadMoreActivityIndicator.frame = CGRect(x: 235, y: 0, width: 50,height: 50)
        loadMoreActivityIndicator.color = UIColor.gray
        
        //Embed the view and the button
        self.view.addSubview(loadMoreView)
        loadMoreView.addSubview(loadMoreBtn)
        loadMoreView.addSubview(loadMoreActivityIndicator)
        self.getUpcomingMovies(page: self.currentPage, flag: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

