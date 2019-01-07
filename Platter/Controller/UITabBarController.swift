//
//  UITabBarController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 21/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class UITabBar: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem?.title = " "
       
    }
    
}
