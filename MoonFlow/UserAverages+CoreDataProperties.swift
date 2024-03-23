//
//  UserAverages+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//
//

import Foundation
import CoreData


extension UserAverages {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserAverages> {
        return NSFetchRequest<UserAverages>(entityName: "UserAverages")
    }
    
    @NSManaged public var averageCycleLength: Int16
    @NSManaged public var averagePeriodLength: Int16
    
}

extension UserAverages : Identifiable {
    
}
