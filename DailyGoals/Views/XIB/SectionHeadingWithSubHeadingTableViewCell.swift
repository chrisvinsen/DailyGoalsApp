//
//  SectionHeadingWithSubHeadingTableViewCell.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 29/04/22.
//

import UIKit

class SectionHeadingWithSubHeadingTableViewCell: UITableViewCell {

    @IBOutlet weak var headingLabel: UILabel!
    @IBOutlet weak var subHeadingLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
