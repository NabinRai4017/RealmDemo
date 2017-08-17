//
//  DepartmentVM.swift
//  RealmDemo
//
//  Created by nabinrai on 8/14/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift



class Department: Object{
    
    dynamic var id:Int = 0
    dynamic var name:String = ""
    
    var staffs = LinkingObjects(fromType: Staff.self, property: "department")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


class DepartmentVM{
    
    // saves department
    class func saveDepartment(newDepartment: Department){
        let depart = Department()
        depart.name = newDepartment.name
        depart.id = newDepartment.id
        depart.staffs = newDepartment.staffs
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(depart)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    // gets all departments
   class func getAllDepartments() ->  Results<Department>?{
        
        do{
            let realm = try Realm()
            let departments = realm.objects(Department.self)
            return departments
            
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
    
    
    // update the existing department
   class func updateDepartment(OldDepartment: Department, newDepartment:Department){
        
        do{
            let realm = try Realm()
            let department = realm.objects(Department.self).filter("id == \(OldDepartment.id)").first
            try realm.write {
                department?.id = newDepartment.id
                department?.name = newDepartment.name
            }
        }catch let error as NSError{
            print(error)
        }
    }
    
    
    // delete only one department related to id
   class func deleteDepartment(id: Int){
        print(id)
        do {
            let realm = try Realm()
            try realm.write {
                if let departToDelete = realm.object(ofType: Department.self, forPrimaryKey: id){
                    realm.delete(departToDelete)
                }
            }
            
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    // delete all 
   class func deleteAllDepartment(){
        
        do {
            let realm = try Realm()
            try realm.write {
                let departToDelete = realm.objects(Department.self)
                realm.delete(departToDelete)
            }
            
        } catch let error as NSError {
            print(error)
        }
    }
    
    
}







