//
//  AuthPageViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 29/03/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class AuthPageViewController: UIViewController {
    
    @IBOutlet weak var infoLbl: UILabel!
    @IBOutlet weak var emailTxtFld: UITextField!
    @IBOutlet weak var passwrdTxtFld: UITextField!
    @IBOutlet weak var confirmTxtFld: UITextField!
    @IBOutlet weak var errorLbl: UILabel!
    @IBOutlet weak var termsAndCondtns: UIButton!
    @IBOutlet weak var acceptTermsSwtch: UISwitch!
    @IBOutlet weak var signUpBtn: UIButton!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        errorLbl.isHidden = true
        
        
        
    }
    
    @IBAction func acceptConditions(_ sender: UISwitch) {
        
    }
    
    @IBAction func checkOutTerms(_ sender: UIButton) {
        
    }
    
    @IBAction func confirmPasswords(_ sender: UITextField) {
        
        errorLbl.isHidden = true
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
        
        
        let alert = UIAlertController(title: "Sign up completed", message: nil, preferredStyle: .alert)
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (cancel) in
            
            self.dismiss(animated: true, completion: nil)
            
        }
        
        alert.addAction(cancel)
        present(alert, animated: true, completion: nil)
        
        
        
        
    }
    
}



