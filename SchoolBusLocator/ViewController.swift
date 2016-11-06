//
//  ViewController.swift
//  SchoolBusLocator
//
//  Created by Paul Freeman on 02/11/2016.
//  Copyright © 2016 Paul Freeman. All rights reserved.
//

import UIKit
import AblyRealtime
import CoreLocation
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    
    @IBOutlet weak var lblCurrentLat: UILabel!
    @IBOutlet weak var lblCurrentLon: UILabel!
    @IBOutlet weak var lblHorizAcc: UILabel!
    @IBOutlet weak var lblSpeedMPH: UILabel!

    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblPositionTime: UILabel!
    @IBOutlet weak var lblDelay: UILabel!

    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnUnsubscribe: UIButton!
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var channel: ARTRealtimeChannel!

    
    var client: ARTRealtime = ARTRealtime(key: "QGOsVA.UnM4VQ:YuOO9DIWTgs2BcPZ")
    var annotation: MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channel = client.channels.get("Position")
        annotation.title = "SchoolBus"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicked(_ sender: AnyObject) {
        
        self.mapView.addAnnotation(self.annotation)
        
        channel.subscribe{ message in
            
        let positionString: String = message.data as! String
            
        //let positionString: String = "37.330432|-122.030018|5.000000|14 mph|November 04 2016 07:38:17.121|November 04 2016 07:41:32.692"
        
        let splitArray = positionString.components(separatedBy: "|")
        
        //CLLocationDegrees
        let lat: Double = Double(splitArray[0] as String)!
        let lon: Double = Double(splitArray[1] as String)!
        let horizAcc: Double = Double(splitArray[2] as String)!
        let speed: String = splitArray[3] as String!
        
        let locTSS: String = splitArray[4] as String!
        let transmitTSS: String = splitArray[5] as String!
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMMM dd yyyy hh:mm:ss.SSS"
        
        dateformatter.date(from: locTSS)
        dateformatter.date(from: transmitTSS)
            
        self.lblCurrentLat.text = splitArray[0] as String
        self.lblCurrentLon.text = splitArray[1] as String
        self.lblHorizAcc.text = splitArray[2] as String
        self.lblSpeedMPH.text = speed
        self.lblPositionTime.text = locTSS
        self.lblCurrentTime.text = dateformatter.string(from: NSDate() as Date)
            
        let delay: Double = NSDate().timeIntervalSince(dateformatter.date(from: locTSS)!)
            
        self.lblDelay.text = String(format: "%.0f seconds", delay)
            
        
        let  locationCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let location: CLLocation = CLLocation.init(coordinate: locationCoord, altitude: 0, horizontalAccuracy: horizAcc, verticalAccuracy: 1, timestamp: dateformatter.date(from: locTSS)!)
            
            let region = MKCoordinateRegionMakeWithDistance(location.coordinate,500, 500)
            self.mapView.setRegion(region, animated: true)
            self.mapView.centerCoordinate = location.coordinate
            self.annotation.coordinate = location.coordinate

            
 
        }
    }

    @IBAction func unsubscribe_clicked(_ sender: Any) {
    
        self.mapView.removeAnnotation(self.annotation)
        channel.unsubscribe()
    }
}
