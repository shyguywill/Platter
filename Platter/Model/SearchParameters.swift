//
//  SearchParameters.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 17/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation


struct Search{
    
    static var searchParamters = [String]()
    
    
    
    static var diet : String {
        
        let selectedDietCell = UserDefaults.standard.object(forKey: Keys.mealOption) as! Int
        
        switch selectedDietCell{
            
        case 0:
            return ""
        case 1:
            return "&diet=high-protein"
        case 2:
            return "&diet=low-carb"
        case 3:
            return "&health=vegan"
        case 4:
            return "&health=vegetarian"
        case 5:
            return "&health=gluten-free"
        case 6:
            return "&health=pescatarian"
            
            
        default:
            break
            
        }
        
        return ""
        
    }
    
}
