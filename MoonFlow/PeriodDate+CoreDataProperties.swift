//
//  PeriodDate+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//
//

import Foundation
import CoreData


extension PeriodDate {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<PeriodDate> {
        return NSFetchRequest<PeriodDate>(entityName: "PeriodDate")
    }
    
    @NSManaged public var date: Date
    
}

extension PeriodDate : Identifiable {
    
}
