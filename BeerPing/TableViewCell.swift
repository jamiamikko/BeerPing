//
//  TableViewCell.swift
//  BeerPing
//
//  Created by Mikko Jämiä on 11/04/2017.
//  Copyright © 2017 BeerBluds. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var barName: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
