//
//  Fridge.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


class Store: Object{
    
    @objc dynamic var name = ""
    @objc dynamic var included : Bool = false
    
    
}
