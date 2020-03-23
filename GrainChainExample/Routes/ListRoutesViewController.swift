//
//  ListRoutesViewController.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 22/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit
import CoreLocation


class ListRoutesViewController: UIViewController {
    var viewModel = ViewModelRoutes()
    fileprivate let locationManager: CLLocationManager = {
        
        let manager = CLLocationManager()
       
        return manager
    }()

    @IBOutlet weak var tableVIew: UITableView!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        tableVIew.delegate = self
        tableVIew.dataSource = self
        // Do any additional setup after loading the view.
        locationManager.requestWhenInUseAuthorization()
        locationManager.requestAlwaysAuthorization()
        navigationController?.navigationBar.prefersLargeTitles = true
        tableVIew.register(UINib(nibName: "RouteTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteTableViewCell")
        self.title = "Routes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(self.action(sender:)))
        
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    locationManager.requestWhenInUseAuthorization()
                    locationManager.requestAlwaysAuthorization()
              
                    
                default:
                print("No Access")
            }
            } else {
                print("Location services are not enabled")
        }
    }
    
    func validatePermision() -> Bool {
        
        if CLLocationManager.locationServicesEnabled() {
                    switch CLLocationManager.authorizationStatus() {
                       case .notDetermined, .restricted, .denied:
                           return false
                       case .authorizedAlways, .authorizedWhenInUse:
                          return true
                       default:
                       print("No Access")
                   }
                   } else {
                       print("Location services are not enabled")
               }
        
        return false
    }
   
    @objc func action(sender: UIBarButtonItem) {
        if !validatePermision() {
            checkPermisionFunction()
        }else{
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
                secondViewController.viewModel?.typeScreen = .recordRoute
               self.navigationController?.pushViewController(secondViewController, animated: true)
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        self.tableVIew.reloadData()
    }

    var checkPermision = false
    func checkPermisionFunction(){
        
        if CLLocationManager.locationServicesEnabled() {
             switch CLLocationManager.authorizationStatus() {
                case .notDetermined, .restricted, .denied:
                    let alertController = UIAlertController(title: "TITLE", message: "Please go to Settings and turn on the permissions", preferredStyle: .alert)
                       let settingsAction = UIAlertAction(title: "Settings", style: .default) { (_) -> Void in
                        guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                               return
                           }
                           if UIApplication.shared.canOpenURL(settingsUrl) {
                               UIApplication.shared.open(settingsUrl, completionHandler: { (success) in })
                            }
                       }
                       let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                       alertController.addAction(cancelAction)
                       alertController.addAction(settingsAction)

                    self.present(alertController, animated: true, completion: nil)
                
                case .authorizedAlways, .authorizedWhenInUse:
                    checkPermision = true
                default:
                print("No Acces")
            }
            } else {
                print("Location services are not enabled")
        }
    }
    
}

extension ListRoutesViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let route = viewModel.getRoute(index: indexPath.row)
        
       
             let storyboard = UIStoryboard(name: "Main", bundle: nil)
             let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
            secondViewController.viewModel?.route = route
            secondViewController.viewModel?.typeScreen = .visualizeRoute
            self.navigationController?.pushViewController(secondViewController, animated: true)
        
    }
    
    
    
}

extension ListRoutesViewController : UITableViewDataSource, CellRouteDelegate{
    func deleteRouteWith(cell: UITableViewCell) {
        
        let alertController = UIAlertController(title: "Atention", message: "Do you want to delete the route?", preferredStyle: .alert)

           // Create the actions
           let okAction = UIAlertAction(title: "OK", style: .default) {
               UIAlertAction in
               
            let index = self.tableVIew.indexPath(for: cell)
            if let indexToDelete = index {
                self.viewModel.deleteRouteWith(index: indexToDelete.row)
            }
            self.tableVIew.reloadData()
           }
       
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) {
               UIAlertAction in
             
           }

           // Add the actions
           alertController.addAction(okAction)
           alertController.addAction(cancelAction)

           // Present the controller
        self.present(alertController, animated: true, completion: nil)
        
        
        
        
    }

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  viewModel.GetRoutes().count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        
        cell.configure(viewModel: viewModel.getViewModelRouteWith(index: indexPath.row))
        cell.delegate = self
        return cell
    }
    
    
    
}
