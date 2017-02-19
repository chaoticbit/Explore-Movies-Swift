//
//  UpcomingMoviesCollectionViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/19/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class UpcomingMoviesCollectionViewController: UICollectionViewController {

    var names: [String] = []
    let loader = UIActivityIndicatorView()
    
    var overview: [String] = []
    var thumbs: [String] = []
    var movieIDs: [Int] = []
    var totalPages: Int = 0
    
    var arrOfThumnails: [UIImage] = []
    var loadMoreRequestMade: Bool = false
    var currentPage:Int = 1
    
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
        
        DispatchQueue.main.async {
            self.getMovies(page: self.currentPage)
            
            if self.names.count > 0 {
                self.loader.stopAnimating()
                self.collectionView?.reloadData()                
            }
        }

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes        

        // Do any additional setup after loading the view.
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            let row = self.collectionView!.indexPathsForSelectedItems
            let selectedItem = row?.first
            let detailVC = segue.destination as? detailViewController
            detailVC?.passedValue = names[(selectedItem?.row)!]
            detailVC?.movieId = movieIDs[(selectedItem?.row)!]            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func getMovies(page: Int)
    {
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
                }
            }
            
        }
        catch {
            
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return self.arrOfThumnails.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath as IndexPath) as! MovieCollectionViewCell
        
        DispatchQueue.main.async {
            cell.posterImage.image = self.arrOfThumnails[indexPath.row]
        }
        // Configure the cell
    
        return cell
    }

    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
