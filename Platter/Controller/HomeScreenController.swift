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
import KeychainAccess
import StoreKit
import Spring

class HomeScreenController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    let userStatus = UserStatus()
    let keychain = Keychain(service: "com.Platter.App")
    
 
    
    @IBOutlet weak var newMeal: UIButton!
    @IBOutlet weak var tokenImage: UIBarButtonItem!
    @IBOutlet weak var tokenLbl: UIBarButtonItem!
    @IBOutlet weak var buttonView: SpringView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem?.title = " "
        
        if userStatus.isFreeUser(){
            tokenImage.image = UIImage(named: "Platoken")?.withRenderingMode(.alwaysOriginal)
        }
        
        firstLaunch()
        launchCounter()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        NotificationCenter.default.addObserver(self, selector: #selector(updateTokens),name: UIApplication.willEnterForegroundNotification, object: nil)
        
        updateTokens()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
       startAnimation()
    }
    
    
    @objc func updateTokens() {
        
        if userStatus.isFreeUser(){
            let tokens = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
            let formattedNumber = NumberFormatter()
            formattedNumber.numberStyle = NumberFormatter.Style.decimal
            
            tokenLbl.title = formattedNumber.string(from: NSNumber(value: tokens))
        }else{
            tokenLbl.title = nil
            tokenImage.isEnabled = false
            tokenImage.image = nil
        }
        
    }
    
        //MARK: - Play sound
    
    @IBAction func newMeal(_ sender: UIButton) {
        
        playSound()
    }
    
    //MARK: - Open store
    
    
    @IBAction func openPurchases(_ sender: UIBarButtonItem) {
        
        performSegue(withIdentifier: "goToPurchases", sender: self)
    }
    
    
    
    
    func playSound() {
        
        do{
            guard let soundURL = Bundle.main.url(forResource: "ButtonSound", withExtension: "mp3")else{ return}
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
            
        }catch let error{
            
            print ("CANT play file because of error: \(error.localizedDescription.debugDescription)")
        }
    
    }
    
    //MARK: - First launch
    
    func firstLaunch() {
        
        let firstTime = FirstLaunch(userDefaults: .standard, key: Keys.firstHomeScreen)
        
        if firstTime.isFirstLaunch{
            
            let firstAlert = UIAlertController(title: "How it all works", message: "Platcoins are the key to discovering recipes. Trade in one Platcoin to see what you can make. You get half a Platcoin per day just for opening Platter! To earn even more, you can share recipes with your friends.", preferredStyle: .alert)
            
            firstAlert.view.tintColor = firstAlert.setColour()
            
            let done = UIAlertAction(title: "Got it", style: .cancel, handler: { (alert) in
                
                if self.userStatus.isFirstTimeUser(){ //Check if user has downloaded app before
                    
                    let showAlert = UIAlertController(title: "Our way of saying thank you 😊", message: "10 Platcoin pack", preferredStyle: .alert)
                    showAlert.view.tintColor = showAlert.setColour()
                    
                    let redeem = UIAlertAction(title: "Redeem now", style: .default) { (redeem) in
                        
                        var token = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                        token += 10
                        UserDefaults.standard.set(token, forKey: Keys.tokenNumber)
                        
                        
                        let tokens = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Float
                        let formattedNumber = NumberFormatter()
                        formattedNumber.numberStyle = NumberFormatter.Style.decimal
                        
                        self.tokenLbl.title = formattedNumber.string(from: NSNumber(value: tokens))
                        
                        showAlert.dismiss(animated: true, completion: nil)
        
                    }
                    
                    let imageView = UIImageView(frame: CGRect(x: 25, y: 90, width: 220, height: 185))
                    
                    imageView.image = UIImage(named: "freeplatcoins")
                    showAlert.view.addSubview(imageView)
                    
                    let height = NSLayoutConstraint(item: showAlert.view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 320)
                    
                    showAlert.view.addConstraint(height)
                    
                    showAlert.addAction(redeem)
                    self.present(showAlert, animated: true, completion: nil)
                    
                    
                    print ("Iamthenight-Iamjustice-IamBatman")
                    self.keychain[Keys.firstDownload] = "Iamthenight-Iamjustice-IamBatman"
                    
                }else{
                    
                    firstAlert.dismiss(animated: true, completion: nil)
                    
                }
            
                
            })
            firstAlert.addAction(done)
            
            self.present(firstAlert, animated: true, completion: nil)
            

            
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

