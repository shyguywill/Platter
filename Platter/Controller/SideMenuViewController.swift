//
//  SideMenuViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    let options = ["Meal preferences","Edit Pantry","Restore purchases"]

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 70
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView()
    }
    

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return options.count
    
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCell", for: indexPath)
        cell.textLabel?.textColor = UIColor(red: 37/255, green: 40/255, blue: 126/255, alpha: 1.0)
        cell.textLabel?.text = options[indexPath.row]
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        self.dismiss(animated: true, completion: nil)
        
        
        if indexPath.row == 0{
            performSegue(withIdentifier: "goToDietLabels", sender: self)
        }
         
        
    }
    
    
    
    

 

}
