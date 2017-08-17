//
//  StaffTblVC.swift
//  RealmDemo
//
//  Created by nabinrai on 8/16/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit
import RealmSwift

class StaffTblVC: UITableViewController {

    var staffs: Results<Staff>? = {
        return StaffsVM.getAllStaffs()
    }()
    var notificationToken: NotificationToken?
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        staffsObserver()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
        
    }
    
    
    func staffsObserver(){
        
        notificationToken = staffs?.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(let results, let deletions, let insertions, let modifications):
                
                tableView.beginUpdates()
                
                //re-order staffs when new pushes happen
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                
                //flash cells when staffs gets more stars
                for row in modifications {
                    let indexPath = IndexPath(row: row, section: 0)
                    let staff = results[indexPath.row]
                    let cell = tableView.cellForRow(at: indexPath) as! StaffTblCell
                    cell.configureWith(staff)
                }
                
                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        }
        
    }
    
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        StaffsVM.deleteAllStaffs()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "addStaff" {
            //let vc = segue.destination as! AddStaffVC
            //vc.index = // 0 or 1, based on whatever
        }
    }
    
    
    
    
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let num = staffs?.count else{
            return 0
        }
        return num
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "StaffTblCell", for: indexPath) as! StaffTblCell
        
        guard let staff = staffs?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configureWith(staff)
        
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StaffDetailVC") as! StaffDetailVC
        guard let staff = staffs?[indexPath.row] else{
            return
        }
        vc.staffInfo = staff
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "STAFFS"
    }
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        // action one
        let renameAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
            print("Edit tapped")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let editVC = storyboard.instantiateViewController(withIdentifier: "AddStaffVC") as! AddStaffVC
            if let staff = self.staffs?[indexPath.row]{
                editVC.editStaff = staff
            }
            self.navigationController?.pushViewController(editVC, animated: true)
        })
        
        renameAction.backgroundColor = .lightGray
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            if let staff = self.staffs?[indexPath.row]{
                 StaffsVM.deleteStaff(id: staff.id)
            }
           
            print("Delete tapped")
            
        })
        deleteAction.backgroundColor = .red
        
        return [deleteAction,renameAction]
        
    }

    
    

}
