//
//  StaffDetailVC.swift
//  RealmDemo
//
//  Created by nabinrai on 8/16/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit

class StaffDetailVC: UIViewController {
    
    
    @IBOutlet weak var idLbl: UILabel!
    @IBOutlet weak var fullNameLbl: UILabel!
    @IBOutlet weak var phoneLbl: UILabel!
    @IBOutlet weak var departmentLbl: UILabel!
    
    var staffInfo: Staff!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }

    
    
    func loadData(){
        idLbl.text = "\(staffInfo.id)"
        fullNameLbl.text = staffInfo.fullName
        phoneLbl.text = staffInfo.phoneNumber
        departmentLbl.text = staffInfo.department?.name ?? "nil"
    }

}
