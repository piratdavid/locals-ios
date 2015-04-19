//
//  FirstViewController.swift
//  Locals
//
//  Created by David Smallbone Tizard on 2015-03-30.
//  Copyright (c) 2015 David Smallbone Tizard. All rights reserved.
//

import UIKit
import MapKit

class FirstViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate, UITextFieldDelegate {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonImageView: UIImageView!

    var navCont: UINavigationController!;
    var addDialogue: UIView!;
    var overlay: UIView!;
    var loadingIndicator: UIActivityIndicatorView!;
    var screenWidth: CGFloat = 1;
    var screenHeigth: CGFloat = 1;
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
        self.screenWidth = UIScreen.mainScreen().applicationFrame.size.width;
        self.screenHeigth = UIScreen.mainScreen().applicationFrame.size.height + 20;

        self.view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        addButtonImageView.userInteractionEnabled = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateRoute", name: appDelegate.placesUpdatedNotificationKey, object: nil)

        //createAddDialogue();
    }
    
    override func viewDidAppear(animated: Bool) {

        let userLocation = mapView.userLocation
        
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000)
//        
//        mapView.setRegion(region, animated: true)
        
        
    }
    
    
    func updateRoute() {
        println("updateRoute");
        tableView.reloadData();
        
        mapView
    }
    
    @IBAction func tapDetected(sender: UITapGestureRecognizer) {
        println("hej")
        
//        UIView.animateWithDuration(0.2, animations: {
//                self.addDialogue.frame = CGRectMake(0, 200, self.screenWidth, self.screenHeigth-200);
//            }
//        )
    }
    
    func mapView(mapView: MKMapView!, didUpdateUserLocation
        userLocation: MKUserLocation!) {
            mapView.centerCoordinate = userLocation.location.coordinate
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return appDelegate.places.count;
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell:CustomCell = CustomCell(style:UITableViewCellStyle.Value1, reuseIdentifier:"cell")
        cell.textLabel?.text = appDelegate.places[indexPath.row].name
        
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func createAddDialogue() {

        addDialogue = UIView();
        navCont = UINavigationController();
        navCont.title = "Hej";
        navCont.navigationBar.backgroundColor = UIColor.blueColor()
        navCont.setToolbarHidden(false, animated: true);
        navCont.view = addDialogue;

        addDialogue.frame = CGRectMake(0, screenHeigth, screenWidth, screenHeigth-200);
        addDialogue.backgroundColor = UIColor.whiteColor()
        var dialogueHeight = (screenHeigth-200)
        var searchField = UITextField(frame:CGRectMake(self.screenWidth/2, dialogueHeight/2-15, 200, 20));
        searchField.center.x = self.view.center.x;
        var borderColor = UIColor.blackColor();
        searchField.layer.borderColor = borderColor.CGColor
        searchField.backgroundColor = UIColor( red: 0.1, green: 0.0, blue:0.2, alpha: 0.1 )
        searchField.delegate = self;
        searchField.addTarget(self, action: "searchFieldDidChange:", forControlEvents: .EditingChanged)
        addDialogue.addSubview(searchField);
        
        overlay = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeigth-200));
        overlay.backgroundColor = UIColor.whiteColor();
        overlay.alpha = 0;
        addDialogue.addSubview(overlay);
        
        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80)) as UIActivityIndicatorView
        loadingIndicator.center.x = self.addDialogue.center.x;
        loadingIndicator.center.y = (self.screenHeigth-200)/2;
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        addDialogue.addSubview(loadingIndicator);
        
        self.parentViewController!.view.addSubview(addDialogue);
    }
    
//    func searchFieldDidChange(textField: UITextField) {
//        if (textField.text != "") {
//            searchYelp(textField.text, location: "Göteborg");
//        }
//    }
    

}

