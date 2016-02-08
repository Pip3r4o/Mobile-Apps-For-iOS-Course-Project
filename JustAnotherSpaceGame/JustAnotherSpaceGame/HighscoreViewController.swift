//
//  HighscoreViewController.swift
//  JustAnotherSpaceGame
//
//  Created by Peter on 07/02/2016.
//  Copyright © 2016 PeterK. All rights reserved.
//

import Parse

class HighscoreViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var scoreLabel: UILabel!
    
    var score: String!
    let locationManager = CLLocationManager()
    var country: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scoreLabel.text = "\(PublicScore.currentScore)";
        usernameTextField.becomeFirstResponder();
        
        self.locationManager.requestAlwaysAuthorization();
        
        self.locationManager.requestWhenInUseAuthorization();
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self;
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
            locationManager.startUpdatingLocation();
        }
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        self.getPlaceName(manager.location!) { (answer) -> Void in
            self.country = answer;
        }
    }
    
    func getPlaceName(location: CLLocation, completion: (answer: String?) -> Void) {
        CLGeocoder().reverseGeocodeLocation(location, completionHandler: {(placemarks, error) -> Void in
            if (error != nil) {
                NSLog("Reverse geocoder failed with an error" + error!.localizedDescription)
                completion(answer: "");
            } else if placemarks!.count > 0 {
                let pm = placemarks![0] as CLPlacemark;
                completion(answer: self.displayLocationInfo(pm));
            } else {
                NSLog("Problems with the data received from geocoder.");
                completion(answer: "");
            }
        })
        
    }
    
    func displayLocationInfo(placemark: CLPlacemark?) -> String
    {
        if let containsPlacemark = placemark
        {
            let country = (containsPlacemark.country != nil) ? containsPlacemark.country : "";
            
            return country!;
        } else {
            return "";
        }
    }
    
    @IBAction func saveHighscore(sender: AnyObject) {
        let highscore = PFObject(className:"Score");
        let scoreAsNumber = PublicScore.currentScore;
        highscore["Points"] = 12;
        highscore["Name"] = "Unknown";
        
        if country != nil {
            highscore["Country"] = country;
        } else {
            highscore["Country"] = "Unknown";
        }
        
        NSLog("\(highscore["Country"])");
        NSLog("\(usernameTextField.text)");
        
        //highscore.saveInBackground();
        //highscore.saveInBackgroundWithBlock({
        //    NSLog("Saved");
        //});
        
        do {
            try highscore.save();
        } catch let error as NSError {
            NSLog("Didnt Save");
            NSLog("\(error)");
        }

        let storyBoard : UIStoryboard = UIStoryboard(name: "Main", bundle:nil);
        
        let gameViewController = storyBoard.instantiateViewControllerWithIdentifier("Main");
        
        self.presentViewController(gameViewController, animated:true, completion:nil);
    }
}