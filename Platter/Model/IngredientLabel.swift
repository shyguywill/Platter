//
//  IngredientLabel.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 01/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import UIKit


struct MissingIngredientsLabel {
    
    var missingIngredientLabel: String
    var textColour : UIColor
    
    
    
    init(numberMissing: Int) {
        
        switch numberMissing {
            
        case 0:
            self.missingIngredientLabel = "\(numberMissing) ingredients needed"
            self.textColour = UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 1.0)
        case 1:
            self.missingIngredientLabel = "\(numberMissing) ingredient needed"
            self.textColour = UIColor(red: (50/255.0), green: (251/255.0), blue: (164/255.0), alpha: 1.0)
        default:
            self.missingIngredientLabel = "\(numberMissing) ingredients needed"
            self.textColour = UIColor.black 
        }
    }

}
