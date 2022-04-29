//
//  WakeUpTimeUseCase.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import Foundation
import UIKit
import CoreData

class WakeUpTimeUseCase {
    let entity = "WakeUpTime"
    
    func save() {
        let entity = NSEntityDescription.entity(forEntityName: entity, in: context)
        let newData = NSManagedObject(entity: entity!, insertInto: context)
        newData.setValue("21", forKey: "age").setValue(Date(), forKey: "datetime")
        newData.setValue("21", forKey: "age").setValue(true, forKey: "is_remind")
        
        do {
            try context.save()
        } catch {
            print("Error saving")
        }
    }
}
