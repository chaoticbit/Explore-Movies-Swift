//
//  customWebViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/11/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import Alamofire

class customWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    
    var imdbId: String = ""
    var castId: Int = 0
    var url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if imdbId == "" {
            loadIMDBPersonView()
        }
        else if castId == 0 {
            loadIMDBMovieView()
        }
        
        myWebView.delegate = self
        // Do any additional setup after loading the view.
    }
    
    func loadIMDBPersonView() {
        Alamofire.request("https://api.themoviedb.org/3/person/\(self.castId)/external_ids?api_key=01082f35da875726ce81a65b79c1d08c").responseJSON { response in
            
            if let jsonValue = response.result.value {
                let results = JSON(jsonValue)
                let imdbCastId = results["imdb_id"].stringValue
                self.url = "http://imdb.com/name/\(imdbCastId)/"
                if let webViewURL = URL(string: self.url) {
                    let webViewURLRequest = URLRequest(url: webViewURL)
                    self.myWebView.loadRequest(webViewURLRequest)
                }
            }
        }
    }
    
    func loadIMDBMovieView() {
        self.url = "http://imdb.com/title/\(self.imdbId)/"
        if let webViewURL = URL(string: self.url) {
            let webViewURLRequest = URLRequest(url: webViewURL)
            self.myWebView.loadRequest(webViewURLRequest)
        }        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
        self.title = myWebView.stringByEvaluatingJavaScript(from: "document.title")
    }
}
