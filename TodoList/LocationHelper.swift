//
//  LocationHelper.swift
//  DiaryApp
//
//  Created by Ty Schenk on 9/6/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation
import MapKit

enum CordPoint {
    case lat
    case long
}

func getAddress() -> CLLocation {
    let locManager = CLLocationManager()
    let authStatus = CLLocationManager.authorizationStatus()
    let inUse = CLAuthorizationStatus.authorizedWhenInUse
    let always = CLAuthorizationStatus.authorizedAlways
    locManager.requestAlwaysAuthorization()
    
    if authStatus == inUse || authStatus == always {
        return locManager.location!
    } else {
        return CLLocation(latitude: 37.3318, longitude: 122.0312)
    }
}
