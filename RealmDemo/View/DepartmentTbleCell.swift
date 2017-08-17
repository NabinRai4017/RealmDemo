//
//  DepartmentTbleCell.swift
//  RealmDemo
//
//  Created by nabinrai on 8/15/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit

class DepartmentTbleCell: UITableViewCell {
    
    @IBOutlet weak var departInfoLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        departInfoLbl.adjustsFontSizeToFitWidth = true
    }

    
    func configureWith(_ depart: Department){
        departInfoLbl.text = "ID: \(depart.id)       Department name: \(depart.name)"
        
    }
    

}
