//
//  searchViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/13/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class searchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    let queue = DispatchQueue(label: "perform_api_call")
    
    var searchActive : Bool = false
    
    var filteredResults = [String]()
    var names: [String] = []
    var overview: [String] = []
    var thumbs: [String] = []
    var movieIDs: [Int] = []
    var arrOfThumnails: [UIImage] = []
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        
        return true
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = true
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
//        searchBar.showsCancelButton = false
        searchActive = false;
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.showsCancelButton = false
        searchBar.text = ""
        searchActive = false;
        searchBar.endEditing(true)
        self.names.removeAll()
        self.filteredResults.removeAll()
        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == "" {
            self.names.removeAll()
            self.filteredResults.removeAll()
            self.searchTableView.reloadData()
        }
        else {
            queue.sync {
                self.names.removeAll()
                self.overview.removeAll()
                self.thumbs.removeAll()
                self.movieIDs.removeAll()
                self.arrOfThumnails.removeAll()
            let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(searchText)")
            do {
                let allMoviesData = try Data(contentsOf: url!)
                let allMovies = try JSONSerialization.jsonObject(with: allMoviesData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                
                if let arrJSON = allMovies["results"] as? [[String: AnyObject]] {
                    if arrJSON.isEmpty == false {
                        for index in 0...arrJSON.count-1 {
                            
                            let aObject = arrJSON[index]
                            if self.names.contains(aObject["title"] as! String) == false {
                                self.names.append(aObject["title"] as! String)
                                self.overview.append(aObject["overview"] as! String)
                                self.movieIDs.append(aObject["id"] as! Int)
                            
                                if aObject["poster_path"] is NSNull{
                                    self.thumbs.append("")
                                    self.arrOfThumnails.append(UIImage(named: "blank_poster_image.jpg")!)
                                }
                                else {
                                    let posterPath: String = aObject["poster_path"] as! String
                                    self.thumbs.append(posterPath)
                                    let url = URL(string: "https://image.tmdb.org/t/p/w185/" + posterPath)
                                    let data = try? Data(contentsOf: url!)
                                    self.arrOfThumnails.append(UIImage(data: data!)!)
                                }
                            }
                        }
                    }
                }
            }
            catch {
                
            }
                self.searchTableView.reloadData()
            }
//            filteredResults = names.filter({ (text) -> Bool in
//                let tmp: String = text
//                let range = tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive)
//                return range != nil
//            })
//            if(filteredResults.count == 0){
//                searchActive = false;
//            } else {
//                searchActive = true;
//            }
            
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
//        if searchActive {
//            return self.filteredResults.count
//        }
//        else {
            return self.names.count
       // }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.posterImage.clipsToBounds = true
        
//        if searchActive {
//            cell.name.text = self.filteredResults[indexPath.row]
//        }
//        else {
            queue.sync {
                cell.name.text = self.names[indexPath.row]
                cell.summary.text = self.overview[indexPath.row]
                cell.posterImage.image = self.arrOfThumnails[indexPath.row]
            }
//        }
        
        return (cell)
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
