# RealmDemo


This is simple demo to demonstrate RealmSwift as an alternative to coredata.

This explains the simple data relationship.



 #### DataModel
 
 This is the model for Staff.
 
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

 
 
 This is the model for department.
 
     class Department: Object{
     
       dynamic var id:Int = 0
       dynamic var name:String = ""
    
       var staffs = LinkingObjects(fromType: Staff.self, property: "department")
    
       override static func primaryKey() -> String? {
            return "id"
       }
    
     }
     
     
 #### Relationship
 
 For many-to-one or one-to-one relationships, simply declare a property with the type of your Object subclass:
 
 Eg. In staff, we have 
   //to-one relationships must be optional
 
       dynamic var department: Department?
       
Similarly, Realm provides linking objects properties to represent inverse relationships.With linking objects properties, you can obtain all objects that link to a given object from a specific property. 
 
Eg. In Department, we have

       var staffs = LinkingObjects(fromType: Staff.self, property: "department")
        
A department object can have a property named staffs that contains all of the staff objects that have this exact department object in their staff property.

 

 #### Saves department

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
    
    
 #### Gets all departments
 
 
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

#### Update the existing department
 
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

 #### Delete only one department related to id
 
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
    
    
    
#### Delete all departments
    
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



Here is guide https://realm.io/docs/swift/latest/

### Output of this demo project.

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/28722125/29398197-00322152-8343-11e7-92a2-581f44be1995.gif) ![ezgif com-video-to-gif copy](https://user-images.githubusercontent.com/28722125/29398201-0842b9e2-8343-11e7-9adf-243c6e274f04.gif) ![ezgif com-video-to-gif copy 5](https://user-images.githubusercontent.com/28722125/29398208-0f2ca218-8343-11e7-84b4-7148bb5f2278.gif) ![ezgif com-video-to-gif copy 4](https://user-images.githubusercontent.com/28722125/29398209-11c45bec-8343-11e7-967b-3c7dbfc85684.gif) ![ezgif com-video-to-gif copy 3](https://user-images.githubusercontent.com/28722125/29398212-14d5bf74-8343-11e7-8837-042c2ba97f4d.gif) ![ezgif com-video-to-gif copy 2](https://user-images.githubusercontent.com/28722125/29398218-18246496-8343-11e7-8597-3f4fbe2bee75.gif)
