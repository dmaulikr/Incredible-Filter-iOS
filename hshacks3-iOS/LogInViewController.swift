//
//  LogInViewController.swift
//  hshacks3-iOS
//
//  Created by Aubhro Sengupta on 3/25/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
import FirebaseTwitterAuthUI
import Fabric
import TwitterKit
import Alamofire


class LogInViewController: UIViewController, FUIAuthDelegate {
    
    let requestURL: String = "https://httpbin.org/post"

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func LogIn(_ sender: Any) {
        // Initialize the Auth UI class.
        // It will provide us with the view controller we
        // will present.
        let authUI = FUIAuth.init(uiWith: FIRAuth.auth()!)
        
        // We set this class as the authUI delegate
        // This is why we implemented the FIRAuthUIDelegate protocol
        // in this view controller
        
        authUI?.delegate = self
        
        // We set the sign in providers here
        authUI?.providers = [FUITwitterAuth(), FUIGoogleAuth()]
        
        // Present the default login view controller provided by authUI
        let authViewController = authUI?.authViewController();
        self.present(authViewController!, animated: true, completion: nil)

    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        let email = user?.email ?? ""
        let defaults = UserDefaults.standard
        defaults.set(email, forKey: "email")
        
        Twitter.sharedInstance().logIn { session, error in
            if (session != nil) {
                let authToken = session?.authToken ?? ""
                let authTokenSecret = session?.authTokenSecret ?? ""
                
                let params: Parameters = [
                    "authToken": authToken,
                    "authTokenSecret": authTokenSecret,
                    "email": email
                ]
                
                Alamofire.request(self.requestURL, method: .post, parameters: params, encoding: JSONEncoding.default)
                    .responseJSON { response in
                        if let json = response.result.value {
                            print("JSON: \(json)")
                        } else {
                            print("Did not receive json")
                        }
                }
                
            } else {
                print("error: \(error?.localizedDescription)");
            }
        }
        
        
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
