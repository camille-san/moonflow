//
//  UserInfos+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//
//

import Foundation
import CoreData


extension UserInfos {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfos> {
        return NSFetchRequest<UserInfos>(entityName: "UserInfos")
    }

    @NSManaged public var averageCycleLength: Int16
    @NSManaged public var averagePeriodLength: Int16

}

extension UserInfos : Identifiable {

}
