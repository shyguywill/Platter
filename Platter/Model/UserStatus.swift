//
//  Tokens.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import KeychainAccess


class UserStatus{
    
    let keychain = Keychain(service: "com.Platter.App")
    
    
    func isFreeUser() -> Bool{
        
        let userDefaults = UserDefaults.standard
        
        return userDefaults.bool(forKey: Keys.userStatus)
        
    }
    
    func isFirstTimeUser() -> Bool{
        
        var bool = true
        
        if keychain[Keys.firstDownload] != nil{
            
            bool = false
        }
        
        
       return bool
    }
    
    

 
    
    
   
    
}



