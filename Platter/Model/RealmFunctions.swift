//
//  RealmMethods.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 18/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


let realm = try! Realm()




public func save<T: Object>(saveItem: T) {
    
    do{
        
        try realm.write {
            
            realm.add(saveItem)
        }
        
    }catch {
        
        print ("error, item could not be added")
    }
    
}


public func delete<T: Object>(deleteItem: T) {
    
    do{
        try realm.write {
            
            realm.delete(deleteItem)
            
        }
    }catch{
        print ("Could not delete item")
        
    }
}


