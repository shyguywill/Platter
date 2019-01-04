//
//  ViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 27/11/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import AVFoundation

class HomeScreenController: UIViewController {
    
    var audioPlayer : AVAudioPlayer?
    
    @IBOutlet weak var newMeal: UIButton!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func newMeal(_ sender: UIButton) {
        
        playSound()
    }
    
    func playSound() {
        
        do{
            guard let soundURL = Bundle.main.url(forResource: "ButtonSound", withExtension: "mp3")else{ return}
            
            print ("File was found at \(soundURL)")
            
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default)
            
            try AVAudioSession.sharedInstance().setActive(true)
            
            audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
            
            audioPlayer?.play()
            
        }catch let error{
            
            print ("CANT play file because of error: \(error.localizedDescription.debugDescription)")
        }
    
    }
    
    


}

