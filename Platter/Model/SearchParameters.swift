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
        
        var dietHold = ""
        
        switch selectedDietCell{
            
        case 0:
            dietHold = ""
        case 1:
            dietHold = "&diet=high-protein"
        case 2:
            dietHold = "&diet=low-carb"
        case 3:
            dietHold = "&health=gluten-free"
        case 4:
            dietHold = "&health=vegan"
        case 5:
            dietHold = "&health=vegetarian"
        case 6:
            dietHold = "&health=pescatarian"
            
        default:
            break
            
        }
        
        return dietHold
        
        
    }
    
}
