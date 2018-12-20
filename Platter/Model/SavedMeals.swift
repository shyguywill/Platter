//
//  SavedMeals.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 11/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


class Meal: Object{
    
    @objc dynamic var meal_url = String()
    
    @objc dynamic var image_url = String()
    
    @objc dynamic var title = String()
    
    @objc dynamic var saved : Bool = false
    
}
