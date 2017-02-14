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
        self.navigationController?.navigationBar.barTintColor = UIColor.lightGray
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
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
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
            queue.async {
                let encodedAdress: String = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                self.names.removeAll()
                self.overview.removeAll()
                self.thumbs.removeAll()
                self.movieIDs.removeAll()
                self.arrOfThumnails.removeAll()
            let url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)")
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
                            }
                        }
                    }
                }
            }
            catch { }
            }
            
            queue.sync {
                self.searchTableView.reloadData()
            }
            
        }
        
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.names.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableViewCell
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero        
        cell.name.text = self.names[indexPath.row]
        cell.summary.text = self.overview[indexPath.row]
        
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
