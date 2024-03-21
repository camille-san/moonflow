//
//  PeriodDate+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
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
