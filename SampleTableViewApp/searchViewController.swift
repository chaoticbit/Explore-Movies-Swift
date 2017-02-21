//
//  searchViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/13/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class searchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate,UISearchBarDelegate {
    
    let queue = DispatchQueue(label: "perform_api_call")        
    let loader = UIActivityIndicatorView()
    
    var searchActive : Bool = false
    var arrOfThumnails: [UIImage] = []
    let searchPreferences = ["Movies", "TV-shows", "People"]
    var selectedSearchPreference: String = ""
    
    var searchResults = [[String: String]]()
    
    var selectedIndex: IndexPath = [0, 0]
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchPreferencesTableView: UITableView!
    
    @IBOutlet weak var searchPrefrencesView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.navigationBar.barTintColor = UIColor.init(colorLiteralRed: 234/255, green: 233/255, blue: 237/255, alpha: 1.0)
        self.loader.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: self.view.frame.height)
        self.loader.isHidden = false
        self.loader.hidesWhenStopped = true
        self.loader.backgroundColor = UIColor.white
        self.loader.color = UIColor.gray
        self.view.addSubview(loader)
        self.view.bringSubview(toFront: loader)
        
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
        self.loader.stopAnimating()
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
        self.searchResults.removeAll()
        self.searchTableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        self.searchTableView.isHidden = false
        self.searchPrefrencesView.isHidden = true
        self.loader.startAnimating()
        
        if searchText == "" {
            self.searchResults.removeAll()
            self.searchTableView.reloadData()
            self.loader.stopAnimating()
        }
        else {
                let encodedAdress: String = searchText.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
                self.searchResults.removeAll()
            
                if self.selectedIndex == [0, 0] {
                    Alamofire.request("https://api.themoviedb.org/3/search/movie?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)").responseJSON{
                        response in
                        
                        if let jsonValue = response.result.value {
                            let results = JSON(jsonValue)["results"]
                            if results.count > 0 {
                                for item in results.arrayValue {
                                    let title = item["title"].stringValue
                                    let overview = item["overview"].stringValue
                                    let movieId = item["id"].stringValue
                                    let obj = ["title": title, "overview": overview, "movieId": movieId]
                                    self.searchResults.append(obj)
                                }
                                self.loader.stopAnimating()
                                self.searchTableView.reloadData()
                            }
                        }
                    }
                }
                    
                else if self.selectedIndex == [0, 1] {
                    Alamofire.request("https://api.themoviedb.org/3/search/tv?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)").responseJSON{
                        response in
                        
                        if let jsonValue = response.result.value {
                            let results = JSON(jsonValue)["results"]
                            if results.count > 0 {
                                for item in results.arrayValue {
                                    let title = item["name"].stringValue
                                    let overview = item["overview"].stringValue
                                    let movieId = item["id"].stringValue
                                    let obj = ["title": title, "overview": overview, "movieId": movieId]
                                    self.searchResults.append(obj)
                                }
                                self.loader.stopAnimating()
                                self.searchTableView.reloadData()
                            }
                        }
                    }
                }
                else if self.selectedIndex == [0, 2] {
                    Alamofire.request("https://api.themoviedb.org/3/search/person?api_key=01082f35da875726ce81a65b79c1d08c&page=1&query=\(encodedAdress)").responseJSON{
                        response in
                        
                        if let jsonValue = response.result.value {
                            let results = JSON(jsonValue)["results"]
                            if results.count > 0 {
                                for item in results.arrayValue {
                                    let title = item["name"].stringValue
                                    let overview = item["overview"].stringValue
                                    let movieId = item["id"].stringValue
                                    let obj = ["title": title, "overview": overview, "movieId": movieId]
                                    self.searchResults.append(obj)
                                }
                                self.loader.stopAnimating()
                                self.searchTableView.reloadData()
                            }
                        }
                    }
                }
        }
        
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        var count: Int?
        
        if tableView == self.searchTableView {
            count = self.searchResults.count
        }
        
        if tableView == self.searchPreferencesTableView {
            count = self.searchPreferences.count
        }
        
        return count!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView == self.searchTableView {
            let searchRow = self.searchResults[indexPath.row]
            print("You selected name : " + searchRow["title"]!)
            if self.selectedIndex == [0, 0] {
                guard let genreMoviesDetailVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "GenreMoviesDetailVC") as? genreMoviesDetailViewController else {
                    print("Could not instantiate view controller with identifier of type GenreMoviesViewController")
                    return
                }
                let searchRow = self.searchResults[indexPath.row]
                genreMoviesDetailVC.passedValue = searchRow["title"]!
                genreMoviesDetailVC.movieId = JSON(searchRow["movieId"]!).intValue
                genreMoviesDetailVC.type = selectedIndex
                self.navigationController?.pushViewController(genreMoviesDetailVC, animated: true)
            }
        }
        
        if tableView == self.searchPreferencesTableView {
            selectedIndex = indexPath
            switch selectedIndex {
            case [0, 0]:
                self.searchBar.placeholder = "Search Movies"
                break
            case [0, 1]:
                self.searchBar.placeholder = "Search TV shows"
                break
            case [0, 2]:
                self.searchBar.placeholder = "Search People"
                break
            default:
                break
            }
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
            
            let searchRow = self.searchResults[indexPath.row]
            
            cell.name.text = searchRow["title"]
            cell.summary.text = searchRow["overview"]
            
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
}
