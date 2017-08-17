//
//  DepartmentVC.swift
//  RealmDemo
//
//  Created by nabinrai on 8/14/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import UIKit
import RealmSwift

class DepartmentVC: UITableViewController {
    
    
    @IBOutlet weak var departNmeTxtFld: UITextField!
    var departs: Results<Department>? = {
        return DepartmentVM.getAllDepartments()
    }()
    var notificationToken: NotificationToken?
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        departmentObserver()
        print(Realm.Configuration.defaultConfiguration.fileURL!)
       
    }

    
    func departmentObserver(){
        
        notificationToken = departs?.addNotificationBlock {[weak self] (changes: RealmCollectionChange) in
            guard let tableView = self?.tableView else { return }
            
            switch changes {
            case .initial:
                tableView.reloadData()
                break
            case .update(let results, let deletions, let insertions, let modifications):
                
                tableView.beginUpdates()
                
                //re-order departs when new pushes happen
                tableView.insertRows(at: insertions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                tableView.deleteRows(at: deletions.map { IndexPath(row: $0, section: 0) },
                                     with: .automatic)
                
                //flash cells when departs gets more stars
                for row in modifications {
                    let indexPath = IndexPath(row: row, section: 0)
                    let depart = results[indexPath.row]
                    let cell = tableView.cellForRow(at: indexPath) as! DepartmentTbleCell
                    cell.configureWith(depart)
                }
                tableView.endUpdates()
                break
            case .error(let error):
                print(error)
                break
            }
        }
        
    }
    
    
    
    @IBAction func addDepart(_ sender: UIBarButtonItem) {
        
        guard let dName = departNmeTxtFld.text, dName != "" else{
            return
        }
        let newDepart = Department()
        newDepart.name = dName.uppercased()
        newDepart.id = Int(arc4random_uniform(1000))
        DepartmentVM.saveDepartment(newDepartment: newDepart)
        departNmeTxtFld.text = ""
    }
    
    
    @IBAction func deleteAll(_ sender: UIBarButtonItem) {
        
        DepartmentVM.deleteAllDepartment()
    }
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let num = departs?.count else{
            return 0
        }
        return num
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseId", for: indexPath) as! DepartmentTbleCell

        guard let depart = departs?[indexPath.row] else {
            return UITableViewCell()
        }
        cell.configureWith(depart)
        
        return cell
    }
    

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyBoard.instantiateViewController(withIdentifier: "StaffsInDepartVC") as! StaffsInDepartVC
        guard let depart = departs?[indexPath.row] else{
            return
        }
        vc.departInfo = depart
        tableView.deselectRow(at: indexPath, animated: true)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "DEPARTMENTS"
    }
    
    
    override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
//        // action one
//        let renameAction = UITableViewRowAction(style: .default, title: "Edit", handler: { (action, indexPath) in
//            print("Rename tapped")
//            
//        })
//        
//        renameAction.backgroundColor = .lightGray
        
        // action two
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete", handler: { (action, indexPath) in
            if let depart = self.departs?[indexPath.row]{
                DepartmentVM.deleteDepartment(id: depart.id)
            }
            print("Delete tapped")
            
        })
        deleteAction.backgroundColor = .red
        
        return [deleteAction]
        
    }
}
