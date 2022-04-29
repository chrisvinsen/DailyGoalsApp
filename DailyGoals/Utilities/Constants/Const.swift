//
//  Const.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import Foundation
import UIKit

class Const {
    
    static let MasterGoalsPriority = [
        GoalsPriority(
            name: "Low",
            shortName: "Low",
            color: UIColor(named: "PriorityLowColor") ?? .gray,
            image: UIImage(named: "PriorityLow")!
        ),
        GoalsPriority(
            name: "Medium",
            shortName: "Med",
            color: UIColor(named: "PriorityMediumColor") ?? .gray,
            image: UIImage(named: "PriorityMedium")!
        ),
        GoalsPriority(
            name: "High",
            shortName: "High",
            color: UIColor(named: "PriorityHighColor") ?? .gray,
            image: UIImage(named: "PriorityHigh")!
        )
    ]
    static let DefaultMasterGoalsPriority = 1 // Medium
    
    static let MasterGoalsStatus = [
        "Active",
        "Completed"
    ]
    static let GoalsStatusActive = 0
    static let GoalsStatusComplete = 1
    static let DefaultMasterGoalsStatus = GoalsStatusActive
    
    
    
    static let TabYesterdayGoals = 0
    static let TabTodayGoals = 1
    static let TabTomorrowGoals = 2
    
    static let SegueToAddDailyGoals = "LoadsAddDailyGoals"
    static let SegueToEditDailyGoals = "LoadsEditDailyGoals"
    static let SegueToEditWakeUpRoutine = "LoadsEditWakeUpRoutine"
    static let SegueToReport = "LoadsReport"
}
