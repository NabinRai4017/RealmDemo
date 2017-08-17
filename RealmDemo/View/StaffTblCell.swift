//
//  StaffTblCell.swift
//  RealmDemo
//
//  Created by nabinrai on 8/16/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit

class StaffTblCell: UITableViewCell {
    
    @IBOutlet weak var stallInfoLbl: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        stallInfoLbl.adjustsFontSizeToFitWidth = true
    }

    
    func configureWith(_ staff: Staff){
        if let departName = staff.department?.name{
            stallInfoLbl.text = "Id: \(staff.id) Name: \(staff.fullName!)   Department name: " +  departName
        }else{
            stallInfoLbl.text = "Id: \(staff.id) Name: \(staff.fullName!) Department name: nil"
        }
        
        
    }
}
