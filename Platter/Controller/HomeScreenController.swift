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

class HomeScreenController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
 
    
    @IBOutlet weak var newMeal: UIButton!
    @IBOutlet weak var tokenImage: UIBarButtonItem!
    @IBOutlet weak var tokenLbl: UIBarButtonItem!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logo = UIImage(named: "logo")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        self.navigationItem.backBarButtonItem?.title = " "
        tokenImage.image = UIImage(named: "Platoken")?.withRenderingMode(.alwaysOriginal)
    
        
        //tokenLbl.title = String(
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        let tokens = UserDefaults.standard.object(forKey: Keys.tokenNumber) as! Double
            
        tokenLbl.title = "\(Int(tokens))"
            
        
        
        
        
    }
    
    @IBAction func newMeal(_ sender: UIButton) {
        
        playSound()
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
    
    


}

