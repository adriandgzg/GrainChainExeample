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
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        stopRecord()
        
    }
    @IBAction func sharedRoute(_ sender: Any) {
        let latitud =  String(self.viewModel?.getFirsPoint()?.coordinate.latitude ?? 0.0)
        let longitud = String(self.viewModel?.getFirsPoint()?.coordinate.longitude ?? 0.0)
        
        let text = "Latitud: " + latitud + " Longitud:" + longitud
        
              // set up activity view controller
              let textToShare = [ text ]
              let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
              activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash

              // exclude some activity types from the list (optional)
        activityViewController.excludedActivityTypes = [ UIActivity.ActivityType.airDrop, UIActivity.ActivityType.postToFacebook ]

              // present the view controller
              self.present(activityViewController, animated: true, completion: nil)
    }
    
    @IBAction func deleteRoute(_ sender: Any) {
        let alertController = UIAlertController(title: "Atention!", message: "Do you want to delete the route?", preferredStyle: .alert)
        let action = UIAlertAction(title: "Aceptar", style: .default) { (action) in
            if let name = self.viewModel?.route?.nameRoute {
                StorageRoutes.shared.deleteRouteWith(name:name )
                self.navigationController?.popToRootViewController(animated: true)
            }
        }
               
        let cancel = UIAlertAction(title: "Cancelar", style: .default) { (action) in}
        alertController.addAction(cancel)
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
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
        self.setRegion(region: mapView.userLocation.coordinate)
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
        if typeScreen.visualizeRoute == viewModel?.typeScreen {
            if let initPoint = viewModel?.getFirsPoint(){
                  self.addAnnotationsOnMap(locationToPoint: initPoint)
            }
            if let finalPoint = viewModel?.getLastPoint(){
                self.addAnnotationsOnMap(locationToPoint:finalPoint)
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
    
    func clearMap(){
        
        for anotation in self.mapView.annotations{
            self.mapView.removeAnnotation(anotation)
        }
        
        for polygons in self.mapView.overlays {
            self.mapView.removeOverlay(polygons)
        }
        
    }
    func stopRecord(){
        locationManager.stopUpdatingLocation()
                   locationManager.stopUpdatingHeading()
    }
    func startRecord(){
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    
    @IBAction func clickRestart(_ sender: Any) {
        if recordingRoute {
            stopRecord()
            lastPoint = nil
            self.viewModel?.clearRoute()
            clearMap()
            self.clickPlay(btnRecord!)
            firstTime = true
        }else{
             self.viewModel?.clearRoute()
             clearMap()
             firstTime = true
             lastPoint = nil
        }
    }
    
    @IBAction func clickPlay(_ sender: Any) {
        recordingRoute = !recordingRoute
        if recordingRoute {
            viewModel?.clearRoute()
            clearMap()
            (sender as! UIButton).setTitle("Stop", for: .normal)
            (sender as! UIButton).backgroundColor = #colorLiteral(red: 0.5843137503, green: 0.8235294223, blue: 0.4196078479, alpha: 1)
            
            startRecord()
            
        }else{
             (sender as! UIButton).setTitle("Record", for: .normal)
             (sender as! UIButton).backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            stopRecord()
            if let final = self.viewModel?.getLastPoint(){
                self.addAnnotationsOnMap(locationToPoint: final)
            }
        }
    }
    
    @IBAction func clickSaveRoute(_ sender: Any) {
        
        if viewModel?.route?.pointsRoute.count == 0{
            return 
        }
        let alertController = UIAlertController(title: "Guardar Ruta", message: "", preferredStyle: .alert)

        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Nombre de la ruta"
        }

        let saveAction = UIAlertAction(title: "Guardar", style: .default, handler: { alert -> Void in
            let txtf = alertController.textFields![0] as UITextField
            self.viewModel?.setNameRoute(name:txtf.text ?? "Default Name" )
            self.viewModel?.addRouteInRoutes()
            self.locationManager.stopUpdatingLocation()
            self.locationManager.stopUpdatingHeading()
           
        })

        let cancelAction = UIAlertAction(title: "Cancelar", style: .default, handler: nil )
        alertController.addAction(cancelAction)
        alertController.addAction(saveAction)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension MapsViewController:MKMapViewDelegate{
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if (overlay is MKPolyline) {
            return viewModel?.getOverlay(overlay: overlay) ?? MKOverlayRenderer()
        }
        return MKOverlayRenderer()
    }
 
}


extension MapsViewController: CLLocationManagerDelegate{
       func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
          let location = locations.last! as CLLocation
          
        
        if lastPoint != nil && lastPoint!.distance(from: locations.last!) > 10 {
            lastPoint = locations.last
            viewModel?.addPoint(point:  locations.last!)
            self.addRoute()

        }else if( firstTime) {
            lastPoint = locations.last!
            self.addAnnotationsOnMap(locationToPoint: lastPoint!)
            firstTime = false
            setRegion(region: location.coordinate)
        }
       }
    func setRegion(region: CLLocationCoordinate2D){
        let coordinateRegion = MKCoordinateRegion(center: region, latitudinalMeters: 200, longitudinalMeters: 200)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
          print(error.localizedDescription)
        manager.stopUpdatingLocation()
                 manager.stopMonitoringSignificantLocationChanges()
       }
    
}

