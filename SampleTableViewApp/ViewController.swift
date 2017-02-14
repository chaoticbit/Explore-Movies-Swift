//
//  ViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/9/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var myTableView: UITableView!
    let loadMoreActivityIndicator = UIActivityIndicatorView()
    
    @IBOutlet weak var refreshActivityIndicator: UIActivityIndicatorView!
    
    let loadMoreView = UIView()
    
    let queue = DispatchQueue(label: "refresh_data")
    let queue1 = DispatchQueue(label: "load_more")
    
    var names: [String] = []
        
    var overview: [String] = []
    var thumbs: [String] = []
    var movieIDs: [Int] = []
    var totalPages: Int = 0
    
    var arrOfThumnails: [UIImage] = []
    var loadMoreRequestMade: Bool = false
    var currentPage:Int = 1
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.names.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected name : " + names[indexPath.row])
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! customTableViewCell
            
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.posterImage.clipsToBounds = true
        
            cell.name.text = self.names[indexPath.row]
            cell.nationality.text = self.overview[indexPath.row]
        
            DispatchQueue.main.async {
                cell.posterImage.image = self.arrOfThumnails[indexPath.row]
            }
        
            return (cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let row = self.myTableView.indexPathForSelectedRow?.row
            let detailVC = segue.destination as? detailViewController
            detailVC?.passedValue = names[row!]
            detailVC?.movieId = movieIDs[row!]
        }
    }
        
    func loadMore(_ button: UIButton)
    {
        self.loadMoreActivityIndicator.isHidden = false
        self.loadMoreActivityIndicator.startAnimating()
        if currentPage <= totalPages {
            queue1.async {
                self.getUpcomingMovies(page: self.currentPage, flag: 1)
            }
        }
    }
    
    func scrollToNewRow()
    {
        let count = self.names.count
        var indexPath = [NSIndexPath]()
        for row in count - 20 ..< count {
            indexPath.append(NSIndexPath(row: row, section: 0))
        }
        
        self.myTableView.insertRows(at: indexPath as [IndexPath], with: UITableViewRowAnimation.none)
        self.myTableView.reloadData()
        self.loadMoreActivityIndicator.stopAnimating()
        self.myTableView.scrollToRow(at: indexPath.first! as IndexPath, at: UITableViewScrollPosition.bottom, animated: true)
    }
    
    @IBAction func RefreshData(_ sender: Any) {
        self.myTableView.isHidden = true
        self.refreshActivityIndicator.isHidden = false
        self.refreshActivityIndicator.startAnimating()
        queue.async {
            self.names.removeAll()
            self.overview.removeAll()
            self.thumbs.removeAll()
            self.movieIDs.removeAll()
            self.arrOfThumnails.removeAll()
            self.currentPage = 1
        
            self.getUpcomingMovies(page: self.currentPage, flag: 0)
            self.myTableView.reloadData()
            self.refreshActivityIndicator.stopAnimating()
            self.refreshActivityIndicator.isHidden = true
            self.myTableView.isHidden = false
        }
    }
    
    
    func getUpcomingMovies(page: Int, flag: Int) {
        let url = URL(string:"https://api.themoviedb.org/3/movie/upcoming?api_key=01082f35da875726ce81a65b79c1d08c&page=\(page)")
        do {
            let allMoviesData = try Data(contentsOf: url!)
            let allMovies = try JSONSerialization.jsonObject(with: allMoviesData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>

            totalPages = allMovies["total_pages"] as! Int
            if let arrJSON = allMovies["results"] as? [[String: AnyObject]] {
                if arrJSON.isEmpty == false {
                    for index in 0...arrJSON.count-1 {
                    
                        let aObject = arrJSON[index]
                        names.append(aObject["title"] as! String)
                        overview.append(aObject["overview"] as! String)
                        movieIDs.append(aObject["id"] as! Int)
                                                
                        if aObject["poster_path"] is NSNull{
                            thumbs.append("")
                            arrOfThumnails.append(UIImage(named: "blank_poster_image.jpg")!)
                        }
                        else {
                            let posterPath: String = aObject["poster_path"] as! String
                            thumbs.append(posterPath)
                            let url = URL(string: "https://image.tmdb.org/t/p/w185/" + posterPath)
                            let data = try? Data(contentsOf: url!)
                            arrOfThumnails.append(UIImage(data: data!)!)
                        }
                        
                    }
                    if(flag == 1) {
                        scrollToNewRow()
                    }
                }
            }
            
            currentPage += 1
            print("current page after incrementing: ", currentPage)
        }
        catch {
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let theHeight = view.frame.size.height //grabs the height of your view
        
        //Create a footer UI View
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
        
        getUpcomingMovies(page: currentPage, flag: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

