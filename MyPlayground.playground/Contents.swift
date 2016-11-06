//: Playground - noun: a place where people can play

import UIKit
import CoreLocation


var str = "Hello, playground"

/*position string makeup
 var locationString = ""
 locationString = locationString + String(format: "%.6f",latestLocation.coordinate.latitude)
 locationString = locationString + "|" + String(format: "%.6f",latestLocation.coordinate.longitude)
 locationString = locationString + "|" + String(format: "%.6f",latestLocation.horizontalAccuracy)
 locationString = locationString + "|" + String(format: "%.0f mph", speed * 2.23693629)
 locationString = locationString + "|" + locationTimeStamp
 locationString = locationString + "|" + now
*/


var positionString: String = "37.330432|-122.030018|5.000000|14 mph|November 04 2016 07:38:17.121|November 04 2016 07:41:32.692"


let splitArray = positionString.components(separatedBy: "|")

//CLLocationDegrees
var lat: Double = Double(splitArray[0] as String)!
var lon: Double = Double(splitArray[1] as String)!
var horizAcc: Double = Double(splitArray[2] as String)!
var speed: String = splitArray[3] as String!

var locTSS: String = splitArray[4] as String!
var transmitTSS: String = splitArray[5] as String!

let dateformatter = DateFormatter()
dateformatter.dateFormat = "MMMM dd yyyy hh:mm:ss.SSS"

dateformatter.date(from: locTSS)
dateformatter.date(from: transmitTSS)

let  locationCoord: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: lat, longitude: lon)

let location: CLLocation = CLLocation.init(coordinate: locationCoord, altitude: 0, horizontalAccuracy: horizAcc, verticalAccuracy: 1, timestamp: dateformatter.date(from: locTSS)!)






