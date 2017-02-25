//
//  LoginViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import FBSDKLoginKit

class LoginViewController: UIViewController {

    var dict : [String : AnyObject]!
    var env: String = "TEST"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        FBSDKSettings.setAppID("267823996974961")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func FBLoginPressed(_ sender: Any) {
        if env == "PROD" {
            let fbLoginManager: FBSDKLoginManager = FBSDKLoginManager()
            fbLoginManager.logIn(withReadPermissions: ["email"], from: self) { (result, error) in
                if error == nil {
                    let fbLoginResult: FBSDKLoginManagerLoginResult = result!
                    if fbLoginResult.grantedPermissions != nil {
                        if fbLoginResult.grantedPermissions.contains("email") {
                            self.getFBUserData()
                            fbLoginManager.logOut()
                        }
                    }
                }
            }
        }
        else if env == "TEST" {
            self.performSegue(withIdentifier: "toTabView", sender: nil)
        }
    }

    func getFBUserData() {
        if FBSDKAccessToken.current() != nil {
            FBSDKGraphRequest(graphPath: "me", parameters: ["fields": "id, name, first_name, last_name, picture.type(large), email"]).start(completionHandler: { (connection, result, error) -> Void in
                if error == nil {
                    self.dict = result as! [String : AnyObject]
                    print(result!)
                    print(self.dict)
                    self.performSegue(withIdentifier: "toTabView", sender: nil)
                }
            })
        }
    }
}
