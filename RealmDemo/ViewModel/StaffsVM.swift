//
//  StaffsVM.swift
//  RealmDemo
//
//  Created by nabinrai on 8/14/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import Foundation
import UIKit
import RealmSwift


class Staff: Object{
    
    // for option declaration for int, bool etc except String
    //var id = RealmOptional<Int32>()
    dynamic var id:Int = 0
    dynamic var fullName: String?
    dynamic var phoneNumber: String?
    // to creat inverse relation
    // one to one relationship
    dynamic var department: Department?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}


class StaffsVM{
    
    // saves Staffs
    class func saveStaff(newStaff: Staff){
        let staff = Staff()
        staff.fullName = newStaff.fullName
        staff.id = newStaff.id
        staff.phoneNumber = newStaff.phoneNumber
        staff.department = newStaff.department
        do {
            let realm = try Realm()
            try realm.write {
                realm.add(staff)
            }
        } catch let error as NSError {
            print(error)
        }
    }
    
    
    // gets all Staffs
    class func getAllStaffs() ->  Results<Staff>?{
        
        do{
            let realm = try Realm()
            let staffs = realm.objects(Staff.self)
            return staffs
            
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
    
    // gets all Staffs
    class func getAllStaffsWith(_departId: Int) ->  Results<Staff>?{
        
        do{
            let realm = try Realm()
            let predicate = NSPredicate(format: "department.id = \(_departId)")
            let staffs = realm.objects(Staff.self).filter(predicate)
            print(staffs.count)
            return staffs
            
        }catch let error as NSError{
            print(error)
        }
        return nil
    }
    
    
    // update the existing Staff
    class func updateStaff(OldStaff: Staff, newStaff:Staff){
        
        do{
            let realm = try Realm()
            guard let staff = realm.objects(Staff.self).filter("id == \(OldStaff.id)").first else{
                return
            }
            try realm.write {
                staff.fullName = newStaff.fullName
//                staff.id = newStaff.id
                staff.phoneNumber = newStaff.phoneNumber
                staff.department = newStaff.department
            }
        }catch let error as NSError{
            print(error)
        }
    }
    
    
    // delete only one staff related to id
    class func deleteStaff(id: Int){
        
        do {
            let realm = try Realm()
            try realm.write {
                guard let staffToDelete = realm.object(ofType: Staff.self, forPrimaryKey: id) else{
                    return
                }
                realm.delete(staffToDelete)
            }
        } catch let error as NSError {
            print(error)
        }
        
    }
    
    // delete all staffs
    class func deleteAllStaffs(){
        
        do {
            let realm = try Realm()
            try realm.write {
                let staffsToDelete = realm.objects(Staff.self)
                realm.delete(staffsToDelete)
            }
            
        } catch let error as NSError {
            print(error)
        }
        
        
    }
}
