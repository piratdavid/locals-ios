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
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var navCont: UINavigationController!;
    var addDialogue: UIView!;
//    var overlay: UIView!;
    //var loadingIndicator: UIActivityIndicatorView!;
//    var screenWidth: CGFloat = 1;
//    var screenHeigth: CGFloat = 1;
    
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate;
    
    
    override func viewDidLoad() {
        super.viewDidLoad();
        
//        self.screenWidth = UIScreen.mainScreen().applicationFrame.size.width;
//        self.screenHeigth = UIScreen.mainScreen().applicationFrame.size.height + 20;

        self.view.addSubview(mapView)
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        activityIndicator.hidesWhenStopped = true;
        
        addButtonImageView.userInteractionEnabled = true;
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "updateItinerary", name: appDelegate.placesUpdatedNotificationKey, object: nil)
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: "showDownloadedImage", name: appDelegate.imageDownloadedNtificationKey, object: nil)
        
        //createAddDialogue();
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(true);
        
    }
    
    func mapViewDidFinishLoadingMap(mapView: MKMapView!) {
//        let userLocation = mapView.userLocation
//        mapView.centerCoordinate = userLocation.location.coordinate
//        let region = MKCoordinateRegionMakeWithDistance(userLocation.location.coordinate, 2000, 2000)
//        mapView.setRegion(region, animated: true)
    }
    
    @IBAction func saveButtonTapped(sender: AnyObject) {
        println("hej")
    }
    
    
    func updateItinerary() {
//        updateRoute();
        tableView.reloadData();
        addAnnotation();
    }
    

    
    func addAnnotation() {
        
        if (appDelegate.places.count > 0) {
            var business: YelpBusiness = appDelegate.places.last!
            
            let annotation = MKPointAnnotation()
            annotation.coordinate = business.location.coordinate
            annotation.title = business.name
            annotation.subtitle = business.shortAddress
            mapView.addAnnotation(annotation)
            mapView.showAnnotations(mapView.annotations, animated: true)
        }
    }
    
    
    func updateRoute() {
        println("updateRoute");
        
        if (appDelegate.places.count < 2) {
            return;
        }
            
        let firstBusiness: YelpBusiness = appDelegate.places[appDelegate.places.count-2];
        let secondBusiness: YelpBusiness = appDelegate.places[appDelegate.places.count-1];
    
        let placemark1 = MKPlacemark(coordinate: firstBusiness.location.coordinate, addressDictionary: nil)
        let source = MKMapItem(placemark: placemark1)
    
        let placemark2 = MKPlacemark(coordinate: secondBusiness.location.coordinate, addressDictionary: nil)
        let destination = MKMapItem(placemark: placemark2)
    
        let request = MKDirectionsRequest()
        request.setSource(source)
        request.setDestination(destination)
        request.transportType = MKDirectionsTransportType.Walking
        request.requestsAlternateRoutes = false
    
        activityIndicator.startAnimating();
        let directions = MKDirections(request: request)
        directions.calculateDirectionsWithCompletionHandler({(response: MKDirectionsResponse!, error: NSError!) in
            if error != nil {
                println(error)
            } else {
                self.showRoute(response)
            }
        })
    }
    
    func showRoute(response: MKDirectionsResponse) {
        
        for route in response.routes as! [MKRoute] {
            mapView.addOverlay(route.polyline, level: MKOverlayLevel.AboveRoads)
            mapView.setVisibleMapRect(route.polyline.boundingMapRect, animated: true);
        }
        activityIndicator.stopAnimating()
    }
    
    func mapView(mapView: MKMapView!, rendererForOverlay
        overlay: MKOverlay!) -> MKOverlayRenderer! {
            let renderer = MKPolylineRenderer(overlay: overlay)
            
            renderer.strokeColor = UIColor.blueColor()
            renderer.lineWidth = 5.0
            return renderer
    }
    
    func tableView(tableView: UITableView!, numberOfRowsInSection section: Int) -> Int
    {
        return appDelegate.places.count;
    }
    
    func tableView(tableView: UITableView!,
        cellForRowAtIndexPath indexPath: NSIndexPath!) -> UITableViewCell!
    {
        let cell:CustomCell = CustomCell(style:UITableViewCellStyle.Value1, reuseIdentifier:"cell")
        var business = appDelegate.places[indexPath.row]
        cell.textLabel?.text = business.name
        cell.detailTextLabel?.text = business.displayCategories
        
        if (business.imageURL != nil) {
            loadImage(business.imageURL!, cell: cell)
        } else {
        }

        return cell
    }
    
    func loadImage(imgURL:NSURL, cell: CustomCell)
    {
        //var imgURL: NSURL = NSURL(string: urlString)!
        let request: NSURLRequest = NSURLRequest(URL: imgURL)
        NSURLConnection.sendAsynchronousRequest(
            request, queue: NSOperationQueue.mainQueue(),
            completionHandler: {(response: NSURLResponse!,data: NSData!,error: NSError!) -> Void in
                if error == nil {
                    cell.imageView?.image = UIImage(data: data)
//                    cell.imageView?.frame = CGRect(origin: CGPointZero, size: CGSize(width: 20.0, height: 20.0));
                    cell.setNeedsLayout()
                }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
   
    
    
//    func mapView(mapView: MKMapView!, didUpdateUserLocation
//        userLocation: MKUserLocation!) {
//            mapView.centerCoordinate = userLocation.location.coordinate
//    }
    
    
//    func createAddDialogue() {
//
//        addDialogue = UIView();
//        navCont = UINavigationController();
//        navCont.title = "Hej";
//        navCont.navigationBar.backgroundColor = UIColor.blueColor()
//        navCont.setToolbarHidden(false, animated: true);
//        navCont.view = addDialogue;
//
//        addDialogue.frame = CGRectMake(0, screenHeigth, screenWidth, screenHeigth-200);
//        addDialogue.backgroundColor = UIColor.whiteColor()
//        var dialogueHeight = (screenHeigth-200)
//        var searchField = UITextField(frame:CGRectMake(self.screenWidth/2, dialogueHeight/2-15, 200, 20));
//        searchField.center.x = self.view.center.x;
//        var borderColor = UIColor.blackColor();
//        searchField.layer.borderColor = borderColor.CGColor
//        searchField.backgroundColor = UIColor( red: 0.1, green: 0.0, blue:0.2, alpha: 0.1 )
//        searchField.delegate = self;
//        searchField.addTarget(self, action: "searchFieldDidChange:", forControlEvents: .EditingChanged)
//        addDialogue.addSubview(searchField);
//        
//        overlay = UIView(frame: CGRectMake(0, 0, screenWidth, screenHeigth-200));
//        overlay.backgroundColor = UIColor.whiteColor();
//        overlay.alpha = 0;
//        addDialogue.addSubview(overlay);
//        
//        loadingIndicator = UIActivityIndicatorView(frame: CGRectMake(0, 0, 80, 80)) as UIActivityIndicatorView
//        loadingIndicator.center.x = self.addDialogue.center.x;
//        loadingIndicator.center.y = (self.screenHeigth-200)/2;
//        loadingIndicator.hidesWhenStopped = true
//        loadingIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
//        addDialogue.addSubview(loadingIndicator);
//        
//        self.parentViewController!.view.addSubview(addDialogue);
//    }
    
//    func searchFieldDidChange(textField: UITextField) {
//        if (textField.text != "") {
//            searchYelp(textField.text, location: "Göteborg");
//        }
//    }
    

}

