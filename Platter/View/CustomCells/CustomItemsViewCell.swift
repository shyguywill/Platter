//
//  CustomItemsViewCell.swift
//  Platter
//
//  Created by Oluwasayofunmi Williams on 04/12/2018.
//  Copyright © 2018 Oluwasayofunmi Williams. All rights reserved.
//

import UIKit

class CustomItemsViewCell: UITableViewCell {
    
    
    @IBOutlet weak var checkImage: UIImageView!
    @IBOutlet weak var ingredientName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
