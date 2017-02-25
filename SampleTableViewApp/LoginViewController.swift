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
    
    @IBOutlet weak var loginPopupView: UIView!
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loginPopupView.isHidden = true
        
        loginEmailTextField.setBottomBorder()
        loginPasswordTextField.setBottomBorder()
        
        FBSDKSettings.setAppID("267823996974961")
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func showLoginViewPopup(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.view.backgroundColor = UIColor.init(colorLiteralRed: 21/255, green: 21/255, blue: 21/255, alpha: 0.5)
            self.loginPopupView.isHidden = false
        }
    }
    
    @IBAction func exitLoginPopupView(_ sender: Any) {
        UIView.animate(withDuration: 0.5) {
            self.loginPopupView.isHidden = true
            self.view.backgroundColor = UIColor.white
        }
    }
    
    @IBAction func loginBtnPressed(_ sender: Any) {
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

extension UITextField {
    func setBottomBorder() {
        self.borderStyle = .none
        self.layer.backgroundColor = UIColor.white.cgColor
        
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
