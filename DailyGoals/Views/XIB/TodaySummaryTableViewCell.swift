//
//  TodaySummaryTableViewCell.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import UIKit

class TodaySummaryTableViewCell: UITableViewCell {

    @IBOutlet weak var rateActivitiesLabel: UILabel!
    @IBOutlet weak var dayInRowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
