//
//  GoalsHolder.swift
//  DailyGoals
//
//  Created by Christianto Vinsen on 28/04/22.
//

import UIKit
import CoreData

class GoalsHolder {
    let entityName = "Goals"
    
    func create(goalsData: GoalsModel) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { return false }
        
        let data = NSManagedObject(entity: entity, insertInto: context)
        data.setValue(goalsData.name, forKey: "name")
        data.setValue(goalsData.minutes, forKey: "minutes")
        data.setValue(goalsData.priorityIdx, forKey: "priority_idx")
        data.setValue(goalsData.statusIdx, forKey: "status_idx")
        data.setValue(goalsData.createdTime, forKey: "created_time")
        
        do {
            try context.save()
            try context.parent?.save()
        } catch {
            print(error)
            return false
        }
        
        return true
    }
    
    func retrieve(predicate: NSPredicate, sortedByKey: String = "", isAsc: Bool = false) -> [GoalsModel]? {
        var response = [GoalsModel]()
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return nil }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        
        fetchRequest.predicate = predicate
        
        if sortedByKey != "" {
            fetchRequest.sortDescriptors = [NSSortDescriptor.init(key: sortedByKey, ascending: isAsc)]
        }
        
        do {
            let result = try context.fetch(fetchRequest)
            print("COUNT \(result.count)")
            for data in result as! [NSManagedObject] {
                response.append(
                    GoalsModel(
                        name: data.value(forKey: "name") as! String,
                        minutes: data.value(forKey: "minutes") as! Int,
                        priorityIdx: data.value(forKey: "priority_idx") as! Int,
                        statusIdx: data.value(forKey: "status_idx") as! Int,
                        createdTime: data.value(forKey: "created_time") as! Date
                    )
                )
            }
        } catch let error as NSError {
            print("Error due to : \(error.localizedDescription)")
        }
        
        return response
    }
    
    func update(goalsData: GoalsModel) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "created_time == %@", goalsData.createdTime as CVarArg)
        
        do {
            let object = try context.fetch(fetchRequest)

            let objectToUpdate = object[0] as! NSManagedObject
            objectToUpdate.setValue(goalsData.name, forKey: "name")
            objectToUpdate.setValue(goalsData.minutes, forKey: "minutes")
            objectToUpdate.setValue(goalsData.priorityIdx, forKey: "priority_idx")
            objectToUpdate.setValue(goalsData.statusIdx, forKey: "status_idx")
            
            do {
                try context.save()
                try context.parent?.save()
            } catch {
                print(error)
                return false
            }
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true
    }
    
    func delete(goalsData: GoalsModel) -> Bool {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return false }
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest.init(entityName: entityName)
        fetchRequest.predicate = NSPredicate(format: "created_time == %@", goalsData.createdTime as CVarArg)
        
        do {
            let objectFrom = try context.fetch(fetchRequest)
            
            let objectToDelete = objectFrom[0] as! NSManagedObject
            context.delete(objectToDelete)

            do {
                try context.save()
                try context.parent?.save()
            } catch {
                print(error)
                return false
            }
        } catch let error as NSError {
            print(error)
            return false
        }
        
        return true
    }
}
