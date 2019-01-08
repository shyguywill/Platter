//
//  Tokens.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


class UserStatus{
    
    
    func isFreeUser() -> Bool{
        
        let userDefaults = UserDefaults.standard
        
        return userDefaults.bool(forKey: Keys.userStatus)
        
    }

 
    
    
   
    
}



