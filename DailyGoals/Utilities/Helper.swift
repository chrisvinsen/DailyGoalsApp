//
//  Helper.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import Foundation

class Helper {
    
    static func dateTimeToString(_ dateTime: Date, _ dateFormat: String = "HH:mm") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
         
        let result = dateFormatter.string(from: dateTime)
        
        return result
    }
    
    static func stringToDateTime(_ dateTimeStr: String, _ dateFormat: String = "M/d/yyyy HH:mm:ss") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat
         
        return dateFormatter.date(from: dateTimeStr)!
    }
}


