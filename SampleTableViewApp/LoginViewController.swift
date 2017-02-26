//
//  LoginViewController.swift
//  SampleTableViewApp
//
//  Created by Atharva Dandekar on 2/24/17.
//  Copyright © 2017 BeyondLogic. All rights reserved.
//

import UIKit
import FBSDKLoginKit
import Firebase

class LoginViewController: UIViewController {

    var dict : [String : AnyObject]!
    var env: String = "TEST"
    
    @IBOutlet weak var loginPopupView: UIView!
    @IBOutlet var registerPopupView: UIView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    
    @IBOutlet weak var loginEmailTextField: UITextField!
    @IBOutlet weak var loginPasswordTextField: UITextField!
    
    @IBOutlet weak var registerEmailTextField: UITextField!
    @IBOutlet weak var registerPasswordTextField: UITextField!
    
    @IBOutlet weak var registerBtn: UIButton!
    @IBOutlet weak var loginBtn: UIButton!
    
    @IBOutlet weak var registerActivityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var loginActivityIndicator: UIActivityIndicatorView!
    
    var effect: UIVisualEffect!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIfLoggedIn()
        
        FBSDKSettings.setAppID("267823996974961")
        
        effect = visualEffectView.effect
        visualEffectView.effect = nil
        visualEffectView.isHidden = true        
        
        loginPopupView.layer.cornerRadius = 5
        registerPopupView.layer.cornerRadius = 5
        
        loginEmailTextField.setBottomBorder()
        loginPasswordTextField.setBottomBorder()
        
        registerEmailTextField.setBottomBorder()
        registerPasswordTextField.setBottomBorder()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func checkIfLoggedIn() {
        FIRAuth.auth()?.addStateDidChangeListener { auth, user in
            if user != nil {
                self.performSegue(withIdentifier: "toTabView", sender: nil)
            } else {
                //
            }
        }
        
    }
    
    func animateIn(view: UIView) {
        visualEffectView.isHidden = false
        self.view.addSubview(view)
//        view.center = self.view.center        
        view.center = CGPoint(x: 188, y: 250)
        
        view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        view.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.visualEffectView.effect = self.effect
            view.alpha = 1
            view.transform = CGAffineTransform.identity
        }
    }
    
    func animateOut(view: UIView) {
        UIView.animate(withDuration: 0.3, animations: {
            view.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            view.alpha = 0
            
            self.visualEffectView.effect = nil
        }) { (success: Bool) in
            view.removeFromSuperview()
            self.visualEffectView.isHidden = true
        }
    }
    
    
    @IBAction func showLoginViewPopup(_ sender: Any) {
        animateIn(view: loginPopupView)
        self.loginEmailTextField.becomeFirstResponder()
        self.loginEmailTextField.text = nil
        self.loginPasswordTextField.text = nil
    }
    
    @IBAction func exitLoginPopupView(_ sender: Any) {
        if self.loginEmailTextField.isFirstResponder {
            self.loginEmailTextField.resignFirstResponder()
        }
        else {
            self.loginPasswordTextField.resignFirstResponder()
        }
        animateOut(view: loginPopupView)
    }
            
    
    @IBAction func showRegisterPopupView(_ sender: Any) {
        animateIn(view: registerPopupView)
        self.registerEmailTextField.becomeFirstResponder()
        self.registerEmailTextField.text = nil
        self.registerPasswordTextField.text = nil
    }
    
    @IBAction func exitRegisterPopupView(_ sender: Any) {
        if self.registerEmailTextField.isFirstResponder {
           self.registerEmailTextField.resignFirstResponder()
        }
        else {
            self.registerPasswordTextField.resignFirstResponder()
        }
        animateOut(view: registerPopupView)
    }
    
    @IBAction func createAccountAction(_ sender: Any) {
        if registerEmailTextField.text == "" {
            let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: nil)
        }
        else {
            self.registerBtn.isHidden = true
            self.registerActivityIndicator.isHidden = false
            self.registerActivityIndicator.startAnimating()
            FIRAuth.auth()?.createUser(withEmail: registerEmailTextField.text!, password: registerPasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    self.registerActivityIndicator.stopAnimating()
                    print("Successfully signed up")
                    self.performSegue(withIdentifier: "toTabView", sender: nil)
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.registerActivityIndicator.stopAnimating()
                    self.registerBtn.isHidden = false
                }
            
            }
        }
    }
    
    @IBAction func loginAction(_ sender: Any) {
        if self.loginEmailTextField.text == "" || self.loginPasswordTextField.text == "" {
            let alertContoller = UIAlertController(title: "Error", message: "Please enter email and password", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertContoller.addAction(defaultAction)
            self.present(alertContoller, animated: true, completion: nil)
        }
        else {
            self.loginBtn.isHidden = true
            self.loginActivityIndicator.isHidden = false
            self.loginActivityIndicator.startAnimating()
            FIRAuth.auth()?.signIn(withEmail: self.loginEmailTextField.text!, password: self.loginPasswordTextField.text!) { (user, error) in
                
                if error == nil {
                    self.loginActivityIndicator.stopAnimating()
                    print("Successfully logged in")
                    self.performSegue(withIdentifier: "toTabView", sender: nil)
                }
                else {
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                    self.loginActivityIndicator.stopAnimating()
                    self.loginBtn.isHidden = false
                }
            }
        }
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
        self.layer.shadowColor = UIColor.lightGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}
