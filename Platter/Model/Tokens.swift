//
//  Tokens.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import RealmSwift


class Token : Object{
    
    @objc dynamic var coin = Int()
    
    
}


class userStatus{
    
    enum status {
        case Premium, Free
    }
    
    
}
