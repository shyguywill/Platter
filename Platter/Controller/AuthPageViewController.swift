//
//  AuthPageViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 29/03/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class AuthPageViewController: UIViewController {
    
    
    
    
    var hasSignedUp = UserDefaults.standard.bool(forKey: Keys.UserSignedUp)
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwrdTxtFld: UITextField!
    @IBOutlet weak var confirmTxtFld: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var termsAndCondtns: UIButton!
    @IBOutlet weak var acceptTermsSwtch: UISwitch!
    @IBOutlet weak var signUpBtn: UIButton!
    @IBOutlet weak var signedUpView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLbl.isHidden = true
        acceptTermsSwtch.isOn = false
        signedUpView.isHidden = true
        
        if hasSignedUp{
            
            userSignedUp()
        }
        
    }
    
    
    @IBAction func confirmPasswordChanged(_ sender: UITextField) {
        
        errorLbl.isHidden = true
    }
    
    
    
    @IBAction func checkOutTerms(_ sender: UIButton) {
        
        
        guard let url = URL(string: "https://termsfeed.com/terms-conditions/326c2821e797d81cbcaeff104b0e2c68") else { return }
        UIApplication.shared.open(url)
        
        
    
    }
    
    
    
    @IBAction func signUpPressed(_ sender: UIButton) {
        
        checkForm()

    }
    
    
    
    func checkForm(){
        
        guard emailTxtFld.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Enter Email"
            return
        }
        
        guard passwrdTxtFld.text?.count != 0 else {
            errorLbl.isHidden = false
            errorLbl.text = "Enter Password"
            return
        }
        
        guard passwrdTxtFld.text == confirmTxtFld.text else {
            errorLbl.isHidden = false
            errorLbl.text = "Passwords must match"
            return
        }
        
        guard acceptTermsSwtch.isOn == true else{
            
            errorLbl.isHidden = false
            errorLbl.text = "Please accept our terms and conditions"
            
            return}
        
        SVProgressHUD.show()
        
        
        Auth.auth().createUser(withEmail: emailTxtFld.text!, password: passwrdTxtFld.text!) { (user, error) in
            
            if error != nil{
                
                SVProgressHUD.dismiss()
                print (error!)
                self.createAlert(message: (error?.localizedDescription)!, title: "Error")
                
            }else{
                
                SVProgressHUD.dismiss()
                print ("Success")
                self.createAlert(message: "Thank you for signing up", title: "Success")
                
                
                self.userSignedUp()
                
                UserDefaults.standard.set(true, forKey: Keys.UserSignedUp)
                
                
                
                
            }
        }
        
        
        
     
        
        
        
        
    }
    
    
    
    func userSignedUp(){
        
        infoLbl.isHidden = true
        emailTxtFld.isHidden = true
        passwrdTxtFld.isHidden = true
        confirmTxtFld.isHidden = true
        termsAndCondtns.isHidden = true
        acceptTermsSwtch.isHidden = true
        signUpBtn.isHidden = true
        
        signedUpView.isHidden = false
        
        
        
        
    }
    
    
    
    func createAlert(message : String, title : String){
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
        
        
        
    
}



