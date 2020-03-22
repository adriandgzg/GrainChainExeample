//
//  MapsViewController.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 21/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit
import MapKit
enum typeScreen {
    case recordRoute
    case visualizeRoute
}
class MapsViewController: UIViewController {
    var viewModel : MapsViewModel? = nil
    @IBOutlet weak var mapView: MKMapView!
    var typeScreen:typeScreen  = .visualizeRoute

    @IBOutlet weak var viewVIsualizeRoute: UIView!
    @IBOutlet weak var viewRecordRoute: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureScreen()
        configureViewModel()
        
      
    
        mapView.delegate = self
//       / Do any additional setup after loading the view.
    }
    func  configureViewModel() {
        viewModel = MapsViewModel()
              
              if let initial = viewModel?.initialLocation {
                  centerMapOnLocation(location: initial)
              }
    }
    func configureScreen(){
        if typeScreen  == .recordRoute{
            viewVIsualizeRoute.isHidden = true
        }else{
            viewRecordRoute.isHidden = true
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.addRoute()
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        if let radius =   viewModel?.regionRadius {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: radius, longitudinalMeters: radius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }

    func addRoute(){
        if let data = viewModel {
            let myPolyline =   data.getRoute()
            if let line = myPolyline {
                self.mapView.addOverlay(line)
            }
        }
    }

}

extension MapsViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
      let lineView = MKPolylineRenderer(overlay: overlay)
      lineView.strokeColor = UIColor.green
        lineView.lineWidth = 1.0
      return lineView
     
    }
    
 
    
}
