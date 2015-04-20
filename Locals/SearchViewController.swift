//
//  SearchViewController.swift
//  Locals
//
//  Created by David Smallbone Tizard on 2015-04-19.
//  Copyright (c) 2015 David Smallbone Tizard. All rights reserved.
//

import Foundation

class SearchViewController: UIViewController, UITextFieldDelegate, UITableViewDelegate {

    @IBOutlet weak var searchField: UITextField!
    @IBOutlet weak var centerYAlignment: NSLayoutConstraint!
    @IBOutlet weak var loadingIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    
    var yelpClient: YelpClient!
    var places: Array<YelpBusiness> = Array()
    var hasSearched: Bool = false;
    
    var dataToPass: AnyObject?
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;

    override func viewDidLoad() {
        
        searchField.addTarget(self, action: "searchFieldDidChange:", forControlEvents: .EditingChanged);
        loadingIndicator.hidesWhenStopped = true        
        
        yelpClient = YelpClient(consumerKey: Config.yelpConsumerKey, consumerSecret: Config.yelpConsumerSecret, accessToken: Config.yelpToken, accessSecret: Config.yelpTokenSecret)
    }
    
    func searchFieldDidChange(textField: UITextField) {

        searchYelp(textField.text, location: "Göteborg");
    }
    
    func searchYelp(term: String, location: String) {
        
        loadingIndicator.startAnimating();
        
        yelpClient.searchWithTerm(term, location: location, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            self.places = (response["businesses"] as! Array).map({
                (business: NSDictionary) -> YelpBusiness in
                return YelpBusiness(dictionary: business)
            })
            self.tableView.reloadData();
            self.loadingIndicator.stopAnimating();
            if (!self.hasSearched) {
                UIView.animateWithDuration(0.5, animations: {
                    self.imageView.alpha = 0
                    self.searchField.setTranslatesAutoresizingMaskIntoConstraints(true)
                    self.searchField.frame.origin.y = 70
                });
                self.hasSearched = true;
            }

            println(response)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func getBusinessFromYelp(id: String) {
        
        yelpClient.getBusiness(id, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                println(response)
            }) { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println(error)
        }
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return self.places.count;
    }
    
    func tableView(tableView: UITableView!, cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell: CustomCell = CustomCell(style:UITableViewCellStyle.Value1, reuseIdentifier:"cell")
        cell.textLabel?.text = self.places[indexPath.row].name
        
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var business = self.places[indexPath.row];
        
        appDelegate.places.append(business);
        NSNotificationCenter.defaultCenter().postNotificationName(appDelegate.placesUpdatedNotificationKey, object: self);
        
        self.dismissViewControllerAnimated(true, completion: {});
    }
    
}