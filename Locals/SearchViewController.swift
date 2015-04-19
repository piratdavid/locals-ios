//
//  SearchViewController.swift
//  Locals
//
//  Created by David Smallbone Tizard on 2015-04-19.
//  Copyright (c) 2015 David Smallbone Tizard. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var yelpClient: YelpClient!

    override func viewDidLoad() {
        
        searchField.addTarget(self, action: "searchFieldDidChange:", forControlEvents: .EditingChanged);
        loadingIndicator.hidesWhenStopped = true        
        
        yelpClient = YelpClient(consumerKey: Config.yelpConsumerKey, consumerSecret: Config.yelpConsumerSecret, accessToken: Config.yelpToken, accessSecret: Config.yelpTokenSecret)
    }
    
    func searchFieldDidChange(textField: UITextField) {
        if (textField.text != "") {
            searchYelp(textField.text, location: "Göteborg");
        }
    }
    
    func searchYelp(term: String, location: String) {
        
        loadingIndicator.startAnimating();
//        overlay.alpha = 0.8
        
        yelpClient.searchWithTerm(term, location: location, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            let results = (response["businesses"] as! Array).map({
                (business: NSDictionary) -> YelpBusiness in
                return YelpBusiness(dictionary: business)
            })
            self.loadingIndicator.stopAnimating();
            UIView.animateWithDuration(0.5, animations: {
                self.imageView.alpha = 0
                self.searchField.frame.origin.y = 70
            });
            
            println(response)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
}