//
//  Connectivity.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import Alamofire
import UIKit


class Connectivity {
    
    
    class var isConnectedToInternet : Bool{
        
        return NetworkReachabilityManager()!.isReachable

    }
    
    class func handleNotConnected(view: UIViewController){
        
        let alert = UIAlertController(title: nil, message: "Uh oh, you are not connected to the internet", preferredStyle: .alert)
        
        alert.view.tintColor = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
        
        let okay = UIAlertAction(title: "Got it", style: .cancel) { (okay) in
            
            alert.dismiss(animated: true, completion: nil)
        }
        
        alert.addAction(okay)
        
        view.present(alert, animated: true, completion: nil)
    
    }
    
}


