//
//  Route.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 20/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit
import MapKit

class Route {
    var route : [CLLocationCoordinate2D] = []
    
    init(){
        self.getPoligone()
    }

    func getPoligone() -> MKPolyline {
        
        let points = ["{34.42367,-118.594836}",
           "{34.423597,-118.595205}",
           "{34.423004,-118.59537}",
           "{34.423044,-118.595806}",
           "{34.423419,-118.596126}",
           "{34.423569,-118.596229}",
           "{34.42382,-118.596192}",
           "{34.42407,-118.596283}",
           "{34.424323,-118.596534}",
           "{34.42464,-118.596858}",
           "{34.42501,-118.596838}",
           "{34.42537,-118.596688}",
           "{34.425690,-118.596683}",
           "{34.42593,-118.596806}",
           "{34.42608,-118.597101}",
           "{34.42634,-118.597094}"
        ]
        
        let cgPoints = points.map { NSCoder.cgPoint(for: $0) }
         let coords = cgPoints.map { CLLocationCoordinate2DMake(CLLocationDegrees($0.x), CLLocationDegrees($0.y)) }
        
         let myPolyline = MKPolyline(coordinates: coords, count: coords.count)
         route = coords
        return myPolyline
    }
}

