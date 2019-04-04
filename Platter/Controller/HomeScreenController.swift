//
//  ViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 27/11/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import AVFoundation
import RealmSwift
import StoreKit
import Spring

class HomeScreenController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    let userSignedUp = UserDefaults.standard.bool(forKey: Keys.UserSignedUp)
    
    
 
    
    @IBOutlet weak var newMeal: UIButton!
    @IBOutlet weak var buttonView: SpringView!
    @IBOutlet weak var logInBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem?.title = " "
        
        if userSignedUp{
            
            logInBtn.setTitle("Coming Soon", for: .normal)
        }
        
        
        
     
        launchCounter()
        playSound()

    }
    

    
    override func viewDidAppear(_ animated: Bool) {
        
       startAnimation()
    }
    
    
 
    
        //MARK: - Play sound
    
    @IBAction func newMeal(_ sender: UIButton) {
        
       audioPlayer?.play()
    }
    
    
    func playSound() {
        
        do{
            guard let soundURL = Bundle.main.url(forResource: "ButtonSound", withExtension: "mp3")else{ return}
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.prepareToPlay()
            
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [.mixWithOthers, .allowAirPlay])
            
            try AVAudioSession.sharedInstance().setActive(true)
            
        }catch let error{
            
            print ("CANT play file because of error: \(error.localizedDescription.debugDescription)")
        }
    
    }
    
    
    
    func launchCounter() {
        
        
        let launch = UserLaunchCount()
        
        if launch.isReviewViewToBeDisplayed(minimumLaunchCount: 10){
            
            SKStoreReviewController.requestReview()
        
        }
        

    }
    
    func startAnimation() {
        
        buttonView.force = 1.0
        buttonView.delay = 0.4
        buttonView.duration = 2.7
        buttonView.repeatCount = 10
        buttonView.animation = "pop"
        
        buttonView.animate()
        
    }
    
    


}

