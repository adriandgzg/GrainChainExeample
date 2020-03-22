//
//  MapsViewModel.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 21/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit
import MapKit

class MapsViewModel {
    
        let regionRadius: CLLocationDistance = 500
        var route : Route? = nil
        var initialLocation = CLLocation(latitude: 21.282778, longitude: -157.829444)
     init(){
        route = Route()
        
        initialLocation =  CLLocation(latitude:   route!.route[0].latitude, longitude: route!.route[0].longitude)
        
    }
    
    func getRoute() -> MKPolyline?
    {
        if let rout = self.route {
            return rout.getPoligone()
        }
        return nil
    }
    
    
    
}
