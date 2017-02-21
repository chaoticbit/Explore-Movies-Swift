//
//  genresViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/11/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class genresViewController: UIViewController, UITableViewDataSource, UIWebViewDelegate {

    @IBOutlet weak var genresTableView: UITableView!
    
    var genres: [String] = ["Action", "Adventure", "Animation", "Comedy", "Crime", "Documentary", "Drama", "Family", "Fantasy", "History", "Horror", "Music", "Mystery", "Romance", "Science Fiction", "TV Movie", "Thriller", "War", "Western"]
    var genreIDs: [Int] = [28, 12, 16, 35, 80, 99, 18, 10751, 14, 36, 27, 10402, 9648, 10749, 878, 10770, 53, 10752, 37]
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (self.genres.count)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("You selected genre : " + genres[indexPath.row])
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "genreCell", for: indexPath) as! genresTableViewCell
        
        cell.backgroundColor = UIColor.clear        
        
        cell.preservesSuperviewLayoutMargins = false
        cell.separatorInset = UIEdgeInsets.zero
        cell.layoutMargins = UIEdgeInsets.zero
        cell.genreLabel.text = genres[indexPath.row]
        
        return (cell)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toGenreMoviesView" {
            let row = self.genresTableView.indexPathForSelectedRow?.row
            let genreMoviesVC = segue.destination as? genreMoviesViewController
            genreMoviesVC?.genreId = genreIDs[row!]
            genreMoviesVC?.genreName = genres[row!]
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
