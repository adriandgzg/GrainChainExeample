//
//  RouteTableViewCell.swift
//  GrainChainExample
//
//  Created by Adrian Dominguez Gómez on 22/03/20.
//  Copyright © 2020 Adrian Dominguez Gómez. All rights reserved.
//

import UIKit

class RouteTableViewCell: UITableViewCell {

    @IBOutlet weak var lblName: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblDistance: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(viewModel:ViewModelCellRoute){
        self.lblName.text = "Name : " +  viewModel.nameRoute
        self.lblDate.text = "Date : " + viewModel.dateOfCreation
        self.lblDistance.text = "Distance : " + viewModel.distance
        
        
    }
    
}
