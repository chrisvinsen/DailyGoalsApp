//
//  Date.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import Foundation

extension Date {
    func get(_ components: Calendar.Component..., calendar: Calendar = Calendar.current) -> DateComponents {
        return calendar.dateComponents(Set(components), from: self)
    }

    func get(_ component: Calendar.Component, calendar: Calendar = Calendar.current) -> Int {
        return calendar.component(component, from: self)
    }

    // Convert local time to UTC (or GMT)
    func toGlobalTime() -> Date {
        let timezone = TimeZone.current
        let seconds = -TimeInterval(timezone.secondsFromGMT(for: self))
        return Date(timeInterval: seconds, since: self)
    }

    // Convert UTC (or GMT) to local time
    func toLocalTime() -> Date {
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset = TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = self.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        return Date(timeIntervalSince1970: timezoneEpochOffset)
    }
    
    var previousDay: Date {
        Calendar.current.date(byAdding: DateComponents(day:-1), to: self)!
    }
    
    var nextDay: Date {
        Calendar.current.date(byAdding: DateComponents(day:+1), to: self)!
    }
}
