//
//  Goal+CoreDataProperties.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/4/22.
//
//

import Foundation
import CoreData


extension Goal {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Goal> {
        return NSFetchRequest<Goal>(entityName: "Goal")
    }

    @NSManaged public var id: UUID!
    @NSManaged public var body: String! 
    @NSManaged public var date: Date!
    @NSManaged public var lastUpdated: Date!

}

extension Goal : Identifiable {

}
