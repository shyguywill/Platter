//
//  SideMenuViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit
import MessageUI

class SideMenuViewController: UITableViewController, MFMailComposeViewControllerDelegate {
    
    let options = ["Dietary Preference","Other Options"]
    let optionsArray = [["None","High-Protein","Low-Carb","Vegan","Vegetarian","Gluten-Free","Pescatarian"],["Contact us","Rate us"]]
    
    var lastSelection : IndexPath! //Enforces selection of only one cell
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
        tableView.allowsMultipleSelection = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    

    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return options.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return options[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        
        return optionsArray[section].count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(red: 37/255, green: 40/255, blue: 126/255, alpha: 1.0)
        cell.textLabel?.text = optionsArray[indexPath.section][indexPath.row]
        
        if indexPath.section == 0{
            cell.accessoryType = loadSavedCell(cell: indexPath.row)
            
        }else{

            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let section = tableView.indexPathForSelectedRow?.section else{return}
            
        if section == 0{
                
            if self.lastSelection != nil {
                tableView.cellForRow(at: self.lastSelection)?.accessoryType = .none
            }
                
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

            self.lastSelection = indexPath
                
            let path = indexPath.row
                
            print (path)
                
            UserDefaults.standard.set(path, forKey: Keys.mealOption)
                
            tableView.reloadData()
        }
        
        if section == 1{
            
            guard let row = tableView.indexPathForSelectedRow?.row else{return}
            
            
            switch row{
                
            case 0:
                let emailTitle = "Feedback"
                let messageBody = "Feature request or bug report?"
                let toRecipents = ["platter.product@gmail.com"]
                let mc: MFMailComposeViewController = MFMailComposeViewController()
                
                
                
                if MFMailComposeViewController.canSendMail(){ //Check if user still has native mail app
                    
                    mc.mailComposeDelegate = self
                    mc.setSubject(emailTitle)
                    mc.setMessageBody(messageBody, isHTML: false)
                    mc.setToRecipients(toRecipents)
                    
                    self.present(mc, animated: true, completion: nil)
                }
                
            case 1:
                
                let appID = 1447882723
                
                let urlStr = "itms-apps://itunes.apple.com/app/viewContentsUserReviews?id=\(appID)"
                
                
                if let url = URL(string: urlStr), UIApplication.shared.canOpenURL(url) {
                    if #available(iOS 10.0, *) {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    } else {
                        UIApplication.shared.openURL(url)
                    }
                }
                
                
            default:
                break
  
            }
            
            //self.dismiss(animated: true, completion: nil)
 
        }

            
        tableView.deselectRow(at: indexPath, animated: true)
        
        
        
    }
    
    //MARK: - Exit mail app
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    //MARK: - Set cell accesory type 
    
    
    func loadSavedCell(cell: Int) -> UITableViewCell.AccessoryType{
        
        if let savedCell = UserDefaults.standard.object(forKey: Keys.mealOption) as? Int{
            
            if savedCell == cell{
                
                return UITableViewCell.AccessoryType.checkmark
            }
            
        }
        
        return UITableViewCell.AccessoryType.none
      
    }
    
    
    

}

extension UIAlertController{
    
    func setColour() -> UIColor{
        
        let platterGreen = UIColor(red: 50/255, green: 251/255, blue: 164/255, alpha: 1.0)
        
        return platterGreen
        
    }
    

}



