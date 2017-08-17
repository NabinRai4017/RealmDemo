//
//  CommonMethods.swift
//  RealmDemo
//
//  Created by nabinrai on 8/15/17.
//  Copyright © 2017 nabin. All rights reserved.
//

import Foundation
import RealmSwift



// deletes all 
func deleteAllOfRealm(){
    
    do {
        let realm = try Realm()
        try realm.write {
            realm.deleteAll()
        }
        
    } catch let error as NSError {
        print(error)
    }
}



