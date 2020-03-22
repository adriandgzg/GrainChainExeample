//
//  ListRoutesViewController.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 22/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit


class ListRoutesViewController: UIViewController {
    var viewModel = ViewModelRoutes()
    @IBOutlet weak var tableVIew: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        tableVIew.delegate = self
        tableVIew.dataSource = self
        // Do any additional setup after loading the view.
        
        navigationController?.navigationBar.prefersLargeTitles = true
        tableVIew.register(UINib(nibName: "RouteTableViewCell", bundle: nil), forCellReuseIdentifier: "RouteTableViewCell")
        self.title = "Routes"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "Add", style: .done, target: self, action: #selector(self.action(sender:)))
    }
    @objc func action(sender: UIBarButtonItem) {
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
                secondViewController.viewModel?.typeScreen = .recordRoute
               self.navigationController?.pushViewController(secondViewController, animated: true)
            
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
        
        let index = self.tableVIew.indexPath(for: cell)
        if let indexToDelete = index {
            self.viewModel.deleteRouteWith(index: indexToDelete.row)
        }
        self.tableVIew.reloadData()
        
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
