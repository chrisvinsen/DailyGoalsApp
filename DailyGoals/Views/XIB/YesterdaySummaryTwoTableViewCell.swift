//
//  YesterdaySummaryTwoTableViewCell.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 29/04/22.
//

import UIKit

class YesterdaySummaryTwoTableViewCell: UITableViewCell {

    @IBOutlet weak var hoursLabel: UILabel!
    @IBOutlet weak var minutesLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var medLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
