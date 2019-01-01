//
//  IngredientLabel.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 01/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation


struct MissingIngredientsLabel {
    
    var missingIngredientLabel: String
    
    
    
    init(numberMissing: Int) {
        
        switch numberMissing {
        case 1:
            self.missingIngredientLabel = "\(numberMissing) ingredient needed"
        default:
            self.missingIngredientLabel = "\(numberMissing) ingredients needed"
        }
    }

}
