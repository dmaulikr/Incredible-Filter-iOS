//
//  TwitterViewController.swift
//  hshacks3-iOS
//
//  Created by Aubhro Sengupta on 3/26/17.
//  Copyright © 2017 Aubhro Sengupta. All rights reserved.
//

import UIKit
import Firebase
import SwiftyJSON

class TwitterViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet var tableView: UITableView!
    @IBOutlet var activity: UIActivityIndicatorView!
    
    var tweets: JSON = []
    
    let rootRef = FIRDatabase.database().reference()
    let cellIdentifier = "TwitterCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        activity.hidesWhenStopped = true
        activity.startAnimating()
        
        let defaults = UserDefaults.standard
        let email = defaults.string(forKey: "email") ?? "none"
        print(email)
        
        let userRef = rootRef.child("users").child("amazing")
        userRef.observe(.value, with: {(snapshot) in
            if let value = snapshot.value as? Array<Any> {
                self.tweets = JSON(value)
                self.tableView.reloadData()
                self.activity.stopAnimating()
            }
            
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.tweets.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: TweetTableViewCell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) as! TweetTableViewCell
        
        cell.titleLabel.text = self.tweets[indexPath.row]["user"]["name"].stringValue
        print("BBBBBBBB ")
        print(self.tweets[indexPath.row])
        cell.tweetTextLabel.text = self.tweets[indexPath.row]["text"].stringValue
        
        let url = URL(string: self.tweets[indexPath.row]["user"]["profile_image_url"].stringValue)
        let data = try? Data(contentsOf: url!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
        cell.tweetImage.image = UIImage(data: data!)
        
        return cell
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
