//
//  UserReview.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 17/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import Foundation
import StoreKit


class UserLaunchCount{
    
    
    func isReviewViewToBeDisplayed(minimumLaunchCount:Int) -> Bool {
        
        let launchCount = UserDefaults.standard.integer(forKey: Keys.numberOfLaunches)
        
        print ("This is launch number \(launchCount)")
        
        if launchCount >= minimumLaunchCount {
            return true
        } else {
            /** Increase launch count by ‘1’ after every launch.**/
            UserDefaults.standard.set((launchCount + 1), forKey: Keys.numberOfLaunches)
        }
        return false
    }
    

    
    
    
    
}
