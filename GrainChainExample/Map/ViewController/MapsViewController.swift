//
//  MapsViewController.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 21/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation


class MapsViewController: UIViewController {
    var viewModel : MapsViewModel? = MapsViewModel()
    var lastPoint: CLLocation? = nil
    var firstTime = true
    var startDate :Date? = nil
    var recordingRoute =  false
    var traveledDistance = 0.0
    @IBOutlet weak var btnRecord: UIButton!
    fileprivate let locationManager: CLLocationManager = {
        let manager = CLLocationManager()
        manager.requestWhenInUseAuthorization()
        return manager
    }()

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var lblInformationROute: UILabel!
    

    @IBOutlet weak var viewVIsualizeRoute: UIView!
    @IBOutlet weak var viewRecordRoute: UIView!
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureScreen()
      
    }
    
    @IBAction func sharedRoute(_ sender: Any) {
    }
    
    @IBAction func deleteRoute(_ sender: Any) {
    }
    func configureLocationManager(){
        if viewModel!.typeScreen == typeScreen.visualizeRoute {
            return
        }
       setUpMapView()
    }
    func setUpMapView() {
          mapView.showsUserLocation = true
          mapView.showsCompass = true
          mapView.showsScale = true
        
          currentLocation()
       }
       
       //MARK: - Helper Method
       func currentLocation() {
          locationManager.delegate = self
          locationManager.desiredAccuracy = kCLLocationAccuracyBest
          if #available(iOS 11.0, *) {
             locationManager.showsBackgroundLocationIndicator = true
          } else {
             // Fallback on earlier versions
          }
         
       }
    
    func  configureMap() {
        if let initial = viewModel?.getInitialLocation() {
                  centerMapOnLocation(location: initial)

          
        }
        
    }
    func configureScreen(){
         mapView.delegate = self
        if viewModel!.typeScreen  == .recordRoute{
           viewVIsualizeRoute.isHidden = true
            self.mapView.showsUserLocation = true
            viewModel?.route?.clearRute()
         
        }else{
            viewRecordRoute.isHidden = true
            configureMap()
            self.addRoute()
           
        }
    }
    override func viewDidAppear(_ animated: Bool) {

        configureLocationManager()
        
    }
    
    func centerMapOnLocation(location: CLLocation) {
        
        if let radius =   viewModel?.regionRadius {
            let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                      latitudinalMeters: radius, longitudinalMeters: radius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
        
        
                
                           
        lblInformationROute.text = viewModel?.getInformation()
                                   
    }

    func addRoute(){
        for over in self.mapView.overlays {
            self.mapView.removeOverlay(over)
        }
        
        
        if let data = viewModel {
            let myPolyline =   data.getRoute()
            if let line = myPolyline {
                self.mapView.addOverlay(line)
            }
        }
    }
    
    func addAnnotationsOnMap(locationToPoint : CLLocation){

        let annotation = MKPointAnnotation()
        annotation.coordinate = locationToPoint.coordinate
        let geoCoder = CLGeocoder ()
        
        geoCoder.reverseGeocodeLocation(locationToPoint, completionHandler: { (placemarks, error) -> Void in
            
            if placemarks != nil {
                if let marks = placemarks   {
                              
                    let placemark = marks[0]
//                    var addressDictionary = placemark.country
                    annotation.title = placemark.name
                              self.mapView.addAnnotation(annotation)
                          }
            }
          
        })
    }
    func InitializeRecord(){
        
    }
    @IBAction func clickRestart(_ sender: Any) {
        self.viewModel?.clearRoute()
        self.addRoute()
        self.clickPlay(btnRecord!)
    }
    
    @IBAction func clickPlay(_ sender: Any) {
        recordingRoute = !recordingRoute
        if recordingRoute {
            (sender as! UIButton).setTitle("Stop", for: .normal)
            (sender as! UIButton).backgroundColor = #colorLiteral(red: 0.4392156899, green: 0.01176470611, blue: 0.1921568662, alpha: 1)
            locationManager.startUpdatingLocation()
            locationManager.startUpdatingHeading()
            
        }else{
             (sender as! UIButton).setTitle("Record", for: .normal)
             (sender as! UIButton).backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            locationManager.stopUpdatingLocation()
            locationManager.stopUpdatingHeading()
        }
    }
    
    @IBAction func clickSaveRoute(_ sender: Any) {
        let alertController = UIAlertController(title: "Guardar Ruta", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nombre"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default, handler: { alert -> Void in
            let txtf = alertController.textFields![0] as UITextField
            self.viewModel?.setNameRoute(name:txtf.text ?? "Default Name" )
            self.viewModel?.addRouteInRoutes()
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopUpdatingHeading()
           
        })

        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil )

    

        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapsViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        
        if (overlay is MKPolyline) {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor =  UIColor.green
            pr.lineWidth = 5
            return pr
        }
        return MKOverlayRenderer()
    }
    
 
    
}


extension MapsViewController: CLLocationManagerDelegate{
    
    
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
          let location = locations.last! as CLLocation
          let currentLocation = location.coordinate
          let coordinateRegion = MKCoordinateRegion(center: currentLocation, latitudinalMeters: 200, longitudinalMeters: 200)
         
//          locationManager.stopUpdatingLocation()
        
        
        if lastPoint != nil && lastPoint!.distance(from: locations.last!) > 10 {
            
            lastPoint = locations.last
            viewModel?.addPoint(point:  locations.last!)
            mapView.setRegion(coordinateRegion, animated: true)
            
           
                
                
            var time = ""
            if startDate == nil {
                startDate = Date()
            } else {
                print("elapsedTime:", String(format: "%.0fs", Date().timeIntervalSince(startDate!)))
                time = "Tiempo " +  String(format: "%.2fs", Date().timeIntervalSince(startDate!)) + "\n"
            }
                     traveledDistance += viewModel?.getFirsPoint()?.distance(from: location) ?? 0.0
                     print("Traveled Distance:",  traveledDistance)
                     lblInformationROute.text = time + "Distancia : " + String(format: "%.2f metros",traveledDistance)
                            
            
            self.addRoute()

        }else if( firstTime) {
            
            lastPoint = locations.last!
            firstTime = false
        }
        
        
       
        
       }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print(error.localizedDescription)
        manager.stopUpdatingLocation()
                 manager.stopMonitoringSignificantLocationChanges()
       }
    
}

