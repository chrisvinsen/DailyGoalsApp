//
//  EmptyDataTableViewCell.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 29/04/22.
//

import UIKit

class EmptyDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var infoLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
