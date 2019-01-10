//
//  DietLabels.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 09/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


class Diet{
    
    var title : String
    var selected : Bool = false
    
    
    init(title: String) {
        self.title = title
    }

}

class DietStored : Object{
    
    @objc dynamic var title = ""
    @objc dynamic var selected = false
    
}






