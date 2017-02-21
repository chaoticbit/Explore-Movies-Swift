//
//  genreMoviesViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/12/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class genreMoviesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var genreMoviesTableView: UITableView!
    let loadMoreActivityIndicator = UIActivityIndicatorView()
    
    let loader = UIActivityIndicatorView()
    let loadMoreView = UIView()
    
    var genreId: Int = -1
    var genreName: String = ""
    var moviesByGenre = [[String: String]]()
    var totalPages: Int = 0
    var arrOfThumnails: [UIImage] = []
    var loadMoreRequestMade: Bool = false
    var currentPage = 1
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.moviesByGenre.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let movieByGenre = self.moviesByGenre[indexPath.row]
        print("You selected name : " + movieByGenre["title"]!)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "genreMoviesViewCell", for: indexPath) as! genreMoviesViewCell
                    
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.posterImage.clipsToBounds = true
        
            let movieByGenre = self.moviesByGenre[indexPath.row]
        
            cell.name.text = movieByGenre["title"]
            cell.summary.text = movieByGenre["overview"]
            DispatchQueue.main.async {
                cell.posterImage.image = self.arrOfThumnails[indexPath.row]
            }
        
            return (cell)
    }
    
    func loadMore(_ button: UIButton)
    {
        self.loadMoreActivityIndicator.isHidden = false
        self.loadMoreActivityIndicator.startAnimating()
        if currentPage <= totalPages {
            self.getMoviesByGenre(page: self.currentPage, flag: 1)
        }
    }
    
    func scrollToNewRow()
    {
        let count = self.moviesByGenre.count
        var indexPath = [NSIndexPath]()
        for row in count - 20 ..< count {
            indexPath.append(NSIndexPath(row: row, section: 0))
        }
        
        self.genreMoviesTableView.insertRows(at: indexPath as [IndexPath], with: UITableViewRowAnimation.none)
        self.genreMoviesTableView.reloadData()
        self.loadMoreActivityIndicator.stopAnimating()
        self.genreMoviesTableView.scrollToRow(at: indexPath.first! as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    func getMoviesByGenre(page: Int, flag: Int)
    {
        Alamofire.request("https://api.themoviedb.org/3/genre/\(genreId)/movies?api_key=01082f35da875726ce81a65b79c1d08c&page=\(page)").responseJSON { response in
            
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
                        self.moviesByGenre.append(obj)
                        
                    }
                    if(flag == 1) {
                        self.scrollToNewRow()
                    }
                    self.currentPage += 1
                    print("current page after incrementing: ", self.currentPage)
                    self.loader.stopAnimating()
                    self.genreMoviesTableView.reloadData()
                    self.loadMoreView.isHidden = false
                    return
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenreMoviesDetailView" {
            let row = self.genreMoviesTableView.indexPathForSelectedRow?.row
            let detailVC = segue.destination as? detailViewController
            let movieByGenre = moviesByGenre[row!]
            detailVC?.passedValue = movieByGenre["title"]!
            detailVC?.movieId = JSON(movieByGenre["movieId"]!).intValue
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = genreName
        
        let theHeight = view.frame.size.height //grabs the height of your view
        
        self.loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.loader.isHidden = false
        self.loader.hidesWhenStopped = true
        self.loader.backgroundColor = UIColor.white
        self.loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        self.loader.startAnimating()

        
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
        
        //API call
        self.getMoviesByGenre(page: self.currentPage, flag: 0)        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
