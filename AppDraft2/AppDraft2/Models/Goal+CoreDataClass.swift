//
//  Goal+CoreDataClass.swift
//  AppDraft2
//
//  Created by Matthew Morris on 4/4/22.
//
//

import Foundation
import CoreData

@objc(Goal)
public class Goal: NSManagedObject {
    
    var title: String {
        return body.trimmingCharacters(in: .whitespacesAndNewlines).components(separatedBy: .newlines).first ?? ""
    }
}
