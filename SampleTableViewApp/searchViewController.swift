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
    
    let searchPreferences = ["Movies", "TV-shows", "People"]
    var selectedSearchPreference: String = ""
    
    var selectedIndex: IndexPath = [0, 0]
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchPreferencesTableView: UITableView!
    
    @IBOutlet weak var searchPrefrencesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 234/255, green: 233/255, blue: 237/255, alpha: 1.0)
        // Do any additional setup after loading the view.
    }    
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(true, animated: true)
        self.searchTableView.isHidden = true
        self.searchPrefrencesView.isHidden = false
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        searchBar.setShowsCancelButton(false, animated: true)
        self.searchTableView.isHidden = false
        self.searchPrefrencesView.isHidden = true
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
        
        self.searchTableView.isHidden = false
        self.searchPrefrencesView.isHidden = true
        
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
                
                var url = URL(string: "")
                
                if self.selectedIndex == [0, 0] {
                    url = URL(string:"https://api.themoviedb.org/3/search/movie?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)")!
                }
                else if self.selectedIndex == [0, 1] {
                    url = URL(string:"https://api.themoviedb.org/3/search/tv?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)")!
                }
                else if self.selectedIndex == [0, 2] {
                    url = URL(string:"https://api.themoviedb.org/3/search/person?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)")!
                }
                
            do {
                let allMoviesData = try Data(contentsOf: url!)
                let allMovies = try JSONSerialization.jsonObject(with: allMoviesData, options: JSONSerialization.ReadingOptions.mutableContainers) as! Dictionary<String, AnyObject>
                
                if let arrJSON = allMovies["results"] as? [[String: AnyObject]] {
                    if arrJSON.isEmpty == false {
                        for index in 0...arrJSON.count-1 {
                            
                            let aObject = arrJSON[index]
                            
                            if self.selectedIndex == [0, 0] {
                                if self.names.contains(aObject["title"] as! String) == false {
                                    self.names.append(aObject["title"] as! String)
                                    self.overview.append(aObject["overview"] as! String)
                                    self.movieIDs.append(aObject["id"] as! Int)
                                }
                            }
                            else if self.selectedIndex == [0, 1] {
                                if self.names.contains(aObject["name"] as! String) == false {
                                    self.names.append(aObject["name"] as! String)
                                    self.overview.append(aObject["overview"] as! String)
                                    self.movieIDs.append(aObject["id"] as! Int)
                                }
                            }
                            else if self.selectedIndex == [0, 2] {
                                if self.names.contains(aObject["name"] as! String) == false {
                                    self.names.append(aObject["name"] as! String)
                                    self.overview.append("")
                                    self.movieIDs.append(aObject["id"] as! Int)
                                }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenreMoviesDetailView" {
            let row = self.searchTableView.indexPathForSelectedRow?.row
            let genreMoviesDetailVC = segue.destination as? genreMoviesDetailViewController
            genreMoviesDetailVC?.passedValue = names[row!]
            genreMoviesDetailVC?.movieId = movieIDs[row!]
        }
    }
    
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count: Int?
        
        if tableView == self.searchTableView {
            count = self.names.count
        }
        
        if tableView == self.searchPreferencesTableView {
            count = self.searchPreferences.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.searchTableView {
            print("You selected name : " + names[indexPath.row])
        }
        
        if tableView == self.searchPreferencesTableView {
            selectedIndex = indexPath
            self.searchPreferencesTableView.reloadData()
            print("selected index : ", selectedIndex)
        }
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        
        if tableView == self.searchTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchCell", for: indexPath) as! searchTableViewCell
            cell.preservesSuperviewLayoutMargins = false
            cell.separatorInset = UIEdgeInsets.zero
            cell.layoutMargins = UIEdgeInsets.zero
            cell.name.text = self.names[indexPath.row]
            cell.summary.text = self.overview[indexPath.row]
            
            return (cell)
        }
        
        else if tableView == self.searchPreferencesTableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: "searchPreferenceCell", for: indexPath) as! searchPreferenceTableViewCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.searchPreferenceLabel.text = self.searchPreferences[indexPath.row]
            
            if selectedIndex == indexPath {
                cell.preferenceSelectedImageView.isHidden = false
            }
            else {
                cell.preferenceSelectedImageView.isHidden = true
            }
            
            return (cell)
        }
        
        else { preconditionFailure ("unexpected cell type") }
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
