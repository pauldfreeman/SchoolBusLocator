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

    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblPositionTime: UILabel!
    
    @IBOutlet weak var lblDelay: UILabel!
    @IBOutlet weak var imgDelay: UIImageView!

    @IBOutlet weak var imgETA: UIImageView!
    @IBOutlet weak var lblETA: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var channelPosition: ARTRealtimeChannel!
    var channelHeartbeat: ARTRealtimeChannel!
    
    var lat: Double!
    var lon: Double!
    var horizAcc: Double!
    var speed: Double!
    
    var locTS: Date!
    var transmitTS: Date!
    var positionReceived: Bool = false
    
    var client: ARTRealtime = ARTRealtime(key: "QGOsVA.UnM4VQ:YuOO9DIWTgs2BcPZ")
    var annotation: MKPointAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channelPosition = client.channels.get("Position")
        channelHeartbeat = client.channels.get("Heartbeat")
        annotation.title = "SchoolBus"
        self.subscribe()
        Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateScreen), userInfo: nil, repeats: true)

    
    }
    
    internal func subscribe() {
        
        self.mapView.addAnnotation(self.annotation)
        
        channelPosition.subscribe
            { message in
                self.updatePosition(positionString: message.data as! String)
        }
        
        channelHeartbeat.subscribe
            { message in
                debugPrint("received heartbeat")
        }
    }
    
    internal func unsubscribe() {
        
        self.mapView.removeAnnotation(self.annotation)
        channelPosition.unsubscribe()
    }
    
    internal func updateScreen()
    {
        if (positionReceived)
        {
        let delay: Double = NSDate().timeIntervalSince(locTS!)
        self.lblDelay.text = String(format: "%.0f seconds", delay)
        if (delay > 60.0){
            lblDelay.textColor = #colorLiteral(red: 1, green: 0.009361755543, blue: 0, alpha: 1)
            imgDelay.image = #imageLiteral(resourceName: "signalBad")
        }else{
            lblDelay.textColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            imgDelay.image = #imageLiteral(resourceName: "signalOK")
        }
        }

    }
    
    internal func updatePosition(positionString: String)
    {
        let splitArray = positionString.components(separatedBy: "|")
        
        //CLLocationDegrees
        lat = Double(splitArray[0] as String)!
        lon = Double(splitArray[1] as String)!
        let horizAcc: Double = Double(splitArray[2] as String)!
        let speed: String = splitArray[3] as String!
  
        let  locationCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
        let location: CLLocation = CLLocation.init(coordinate: locationCoord, altitude: 0, horizontalAccuracy: horizAcc, verticalAccuracy: 1, timestamp: locTS!)
        
        let region = MKCoordinateRegionMakeWithDistance(location.coordinate,500, 500)
        self.mapView.setRegion(region, animated: true)
        self.mapView.centerCoordinate = location.coordinate
        self.annotation.coordinate = location.coordinate
        
        positionReceived = true
    }

}
