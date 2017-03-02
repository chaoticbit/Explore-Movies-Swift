//
//  ErrorViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/22/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit

class ErrorViewController: UIViewController {
    
    var error: String = ""
    var controller: String = ""
    
    @IBOutlet weak var errorLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        if error != "" {
            errorLabel.text = error
        }
        // Do any additional setup after loading the view.
    }
    
    @IBAction func handleTryAgain(_ sender: Any) {
        switch controller {
        case "home":
            self.performSegue(withIdentifier: "backToHomePage", sender: self)
            break
        default:
            print("default")
            break
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
