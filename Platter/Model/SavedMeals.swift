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
    
    @objc dynamic var meal_url = ""
    
    @objc dynamic var image_URL = ""
    
    @objc dynamic var title = ""
    
    @objc dynamic var saved = false
    
}
