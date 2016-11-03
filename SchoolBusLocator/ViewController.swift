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

    @IBOutlet weak var btnSubscribe: UIButton!
    
    var locationManager: CLLocationManager = CLLocationManager()
    var startLocation: CLLocation!
    
    var client: ARTRealtime = ARTRealtime(key: "QGOsVA.UnM4VQ:YuOO9DIWTgs2BcPZ")

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //let client =
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func clicked(_ sender: AnyObject) {
        let channel = client.channels.get("Position")
        
        channel.subscribe{ message in
            debugPrint(message.data)
        }
    }

}
