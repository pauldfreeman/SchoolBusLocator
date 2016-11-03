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

class ViewController: UIViewController {

    
    @IBOutlet weak var lblCurrentLat: UILabel!
    @IBOutlet weak var lblCurrentLon: UILabel!
    @IBOutlet weak var lblHorizAcc: UILabel!
    @IBOutlet weak var lblSpeedMPH: UILabel!

    @IBOutlet weak var lblCurrentTime: UILabel!
    @IBOutlet weak var lblPositionTime: UILabel!
    @IBOutlet weak var lblDelay: UILabel!
    
    @IBOutlet weak var btnSubscribe: UIButton!
    @IBOutlet weak var btnUnsubscribe: UIButton!
    
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    var channel: ARTRealtimeChannel!
    
    var client: ARTRealtime = ARTRealtime(key: "QGOsVA.UnM4VQ:YuOO9DIWTgs2BcPZ")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        channel = client.channels.get("Position")

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicked(_ sender: AnyObject) {
        
        channel.subscribe{ message in
            debugPrint(message.data as! String)
        }
    }

    @IBAction func unsubscribe_clicked(_ sender: Any) {
    
        channel.unsubscribe()
    }
}
