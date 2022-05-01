//
//  WakeUpTimeHolder.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import UIKit
import CoreData

class WakeUpTimeHolder {
    let entityName = "WakeUpTime"
    
    func create(wakeUpTimeData: [WakeUpTimeModel]) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return false }
        
        for wakeUpTime in wakeUpTimeData {
            let data = NSManagedObject(entity: entity, insertInto: context)
            data.setValue(wakeUpTime.dateTime, forKey: "date_time")
            data.setValue(wakeUpTime.dayOfWeek, forKey: "day_of_week")
            data.setValue(wakeUpTime.isRemind, forKey: "is_remind")
        }
        
        do {
            try context.save()
            try context.parent?.save()
        } catch {
            print("Something Wrong on GoalsHolder create")
            return false
        }
        
        return true
    }
    
    func retrieve(sortedByKey: String = "", isAsc: Bool = false) -> [WakeUpTimeModel]? {
        var response = [WakeUpTimeModel]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        if sortedByKey != "" {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: sortedByKey, ascending: isAsc)]
        }
        
        do {
            let result = try context.fetch(fetchRequest)
            for data in result as! [NSManagedObject] {
                response.append(
                    WakeUpTimeModel(
                        dateTime: data.value(forKey: "date_time") as! Date,
                        dayOfWeek: data.value(forKey: "day_of_week") as! Int,
                        isRemind: data.value(forKey: "is_remind") as! Bool
                    )
                )
            }
        } catch let error as NSError {
            print("Error due to : \(error.localizedDescription)")
        }
        
        return response
    }
    
    func update(wakeUpTimeData: [WakeUpTimeModel]) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        for wakeUpTime in wakeUpTimeData {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
            fetchRequest.predicate = NSPredicate(format: "day_of_week == \(wakeUpTime.dayOfWeek)")
            do {
                let object = try context.fetch(fetchRequest)
                if object.count == 0 {
                    continue
                }

                let objectToUpdate = object[0] as! NSManagedObject
                objectToUpdate.setValue(wakeUpTime.dateTime, forKey: "date_time")
                objectToUpdate.setValue(wakeUpTime.dayOfWeek, forKey: "day_of_week")
                objectToUpdate.setValue(wakeUpTime.isRemind, forKey: "is_remind")
                do {
                    try context.save()
                    try context.parent?.save()
                } catch {
                    print("Something Wrong on GoalsHolder create")
                    return false
                }
            } catch let error as NSError {
                print("Error due to : \(error.localizedDescription)")
                return false
            }
        }
        
        return true
    }
    
    func deleteAll() -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        do {
            let objectFromList = try context.fetch(fetchRequest)
            
            for objectFrom in objectFromList {
                let objectToDelete = objectFrom as! NSManagedObject
                context.delete(objectToDelete)
            }

            do {
                try context.save()
                try context.parent?.save()
            } catch {
                print("Something Wrong on GoalsHolder create")
                return false
            }
        } catch let error as NSError {
            print("Error due to : \(error.localizedDescription)")
            return false
        }
        
        return true
    }
}
