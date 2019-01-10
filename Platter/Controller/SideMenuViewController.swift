//
//  SideMenuViewController.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 07/01/2019.
//  Copyright © 2019 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class SideMenuViewController: UITableViewController {
    
    let options = ["Dietry preference","Pantry","Platcoins"]
    let optionsArray = [["None(Default)","High-Protein","Low-Carb","Gluten-Free","Vegan","Vegetarian","Pescatarian"],["Edit Pantry"],["Restore Purchases"]]
    
    var lastSelection : IndexPath!
    
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
        }
        

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let section = tableView.indexPathForSelectedRow?.section{
            
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
            
            tableView.deselectRow(at: indexPath, animated: true)
            
        }
        
        
        

        //self.dismiss(animated: true, completion: nil)
        
        
        
    }
    
    
    func loadSavedCell(cell: Int) -> UITableViewCell.AccessoryType{
        
        var selected = UITableViewCell.AccessoryType.none
        
        if let savedCell = UserDefaults.standard.object(forKey: Keys.mealOption) as? Int{
            
            if savedCell == cell{
                
                selected = UITableViewCell.AccessoryType.checkmark
            }
            
        }
        
        return selected
      
        
    }
    
    
    
    

 

}
