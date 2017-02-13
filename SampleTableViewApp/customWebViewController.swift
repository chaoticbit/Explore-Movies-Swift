//
//  customWebViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/11/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class customWebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var myWebView: UIWebView!
    
    var imdbId: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(imdbId)
        myWebView.delegate = self
            if let webViewURL = URL(string: "http://imdb.com/title/\(imdbId)/") {
                let webViewURLRequest = URLRequest(url: webViewURL)
                myWebView.loadRequest(webViewURLRequest)
            }
        // Do any additional setup after loading the view.
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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
