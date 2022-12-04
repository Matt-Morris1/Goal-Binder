//
//  CoreDataManager.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/4/22.
//

import Foundation
import CoreData

class CoreDataManager {
    
    static let shared = CoreDataManager(modelName: "MyGoals")
    
    let persistentContainer: NSPersistentContainer
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    init(modelName: String) {
        persistentContainer = NSPersistentContainer(name: modelName)
    }
    
    func load(completion: (() -> Void)? = nil) {
        persistentContainer.loadPersistentStores { description, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        if viewContext.hasChanges {
            do {
                try viewContext.save()
            } catch {
                print("An error occured while saving \(error.localizedDescription)")
            }
            
        }
    }
}

//MARK: - Helper Functions

extension CoreDataManager {
    func createGoal() -> Goal {
        let goal = Goal(context: viewContext)
        goal.id = UUID()
        goal.body = ""
        goal.date = Date()
        goal.lastUpdated = Date()
        save()
        return goal
    }
    
    func fetchGoals() -> [Goal] {
        let request: NSFetchRequest<Goal> = Goal.fetchRequest()
        let sortDescriptor = NSSortDescriptor(keyPath: \Goal.lastUpdated, ascending: false)
        request.sortDescriptors = [sortDescriptor]
        return (try? viewContext.fetch(request)) ?? []
    }
    
    func deleteGoal(_ goal: Goal) {
        viewContext.delete(goal)
        save()
    }
}
