//
//  AddStaffVC.swift
//  RealmDemo
//
//  Created by nabinrai on 8/16/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit
import RealmSwift

class AddStaffVC: UIViewController {
    
    
    @IBOutlet weak var departsInPicker: UIPickerView!
    @IBOutlet weak var fullNameTxtFld: UITextField!
    @IBOutlet weak var phoneTxtFld: UITextField!
    
    var departs: Results<Department>? = {
        return DepartmentVM.getAllDepartments()
    }()
    
    
    var editStaff: Staff?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        if let staff = editStaff{
            fullNameTxtFld.text = staff.fullName
            phoneTxtFld.text = staff.phoneNumber
        }
        departsInPicker.delegate = self
        departsInPicker.dataSource = self
    }

    
    
    
    
    @IBAction func addStaffBtn(_ sender: UIButton) {
        
        guard let staffname = fullNameTxtFld.text, let phoneNum = phoneTxtFld.text, staffname != "", phoneNum != "" else{
            return
        }
        let newStaff = Staff()
        newStaff.fullName = staffname.uppercased()
        newStaff.phoneNumber = phoneNum.uppercased()
        if  departs?.count == 0 {
            newStaff.department = nil
        }else{
            let index = departsInPicker.selectedRow(inComponent: 0)
            let depart = departs?[index]
            newStaff.department = depart
        }
        if let staff = editStaff{
            newStaff.id = staff.id
            StaffsVM.updateStaff(OldStaff: staff, newStaff: newStaff)
        }else{
            newStaff.id = Int(arc4random_uniform(1000))
            StaffsVM.saveStaff(newStaff: newStaff)
        }
        self.navigationController?.popViewController(animated: true)
        
        
    }
    
    
    

}


extension AddStaffVC: UIPickerViewDelegate, UIPickerViewDataSource{
    
    // returns the number of 'columns' to display.
   
    func numberOfComponents(in pickerView: UIPickerView) -> Int{
        
        return 1
    }
    
    
    // returns the # of rows in each component..
   
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        
        guard let count = departs?.count else {
            return 0
        }
        return count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?{
        
        guard let departments = departs else {
            return ""
        }
        return departments[row].name
    }
    
    
}
