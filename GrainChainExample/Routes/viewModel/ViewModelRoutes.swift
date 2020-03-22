//
//  RoutesViewModel.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 20/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit

class ViewModelRoutes {
    init(){
        
    }
    func GetRoutes() -> [Route]
    {
       return  StorageRoutes.shared.arrRoutes ?? []
        
    }
    
    func getViewModelRouteWith(index:Int)-> ViewModelCellRoute{
        
        let viewcell = ViewModelCellRoute()
        
        if let  route =  StorageRoutes.shared.arrRoutes?[index]{
            viewcell.nameRoute = route.nameRoute
            viewcell.distance  = String(route.getDistance())
            if route.pointsRoute.count > 0 {
                
              let formatter = DateFormatter()
                formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                formatter.dateFormat = "dd-MMM-yyyy"
                let myStringafd = formatter.string(from: route.pointsRoute[0].timestamp)
                
                viewcell.dateOfCreation = myStringafd
            }
            
        }
        return viewcell
    }
    func getRoute(index:Int)-> Route?{
        
        if let  route =  StorageRoutes.shared.arrRoutes?[index]{
            return route
        }
        
        return nil
        
    }
    
    func deleteRouteWith(index:Int){
        StorageRoutes.shared.deleteCard(index: index)
    }
}


protocol CellRouteDelegate {
    func deleteRouteWith(cell:UITableViewCell)
}
