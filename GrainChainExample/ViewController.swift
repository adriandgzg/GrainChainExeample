//
//  ViewController.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 20/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()        // Do any additional setup after loading the view.
        
    }

    @IBAction func clickInitializeDemo(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
//        let secondViewController = storyboard.instantiateViewController(withIdentifier: "MapsViewController") as! MapsViewController
        
         let secondViewController = storyboard.instantiateViewController(withIdentifier: "ListRoutesViewController") as! ListRoutesViewController
        
       self.navigationController?.pushViewController(secondViewController, animated: true)
    
        
    }
    
}

