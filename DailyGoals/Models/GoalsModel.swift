//
//  Goals.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 27/04/22.
//

import Foundation

struct GoalsModel {
    var name: String
    var minutes: Int
    var priorityIdx: Int
    var statusIdx: Int
    
    init(name: String, minutes: Int, priorityIdx: Int, statusIdx: Int) {
        self.name = name
        self.minutes = minutes
        self.priorityIdx = priorityIdx
        self.statusIdx = statusIdx
    }
    
    func getFormattedMinutes() -> String {
        let hours = minutes / 60
        let minutes = minutes % 60

        let hoursString = hours > 0 ? "\(hours) hrs" : ""
        let minutesString = minutes > 0 ? "\(minutes) min" : ""
        
        return "\(hoursString)\(hoursString == "" ? "" : " ")\(minutesString)"
    }
    
    func getGoalsPriority() -> GoalsPriority {
        return Const.MasterGoalsPriority[priorityIdx]
    }
    
    func getStatusName() -> String {
        return Const.MasterGoalsStatus[statusIdx]
    }
    
    func getHourOnly() -> Int {
        return minutes / 60
    }
    
    func getMinuteOnly() -> Int {
        return minutes % 60
    }
}
