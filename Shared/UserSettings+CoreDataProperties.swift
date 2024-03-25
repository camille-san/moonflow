//
//  UserSettings+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//
//

import Foundation
import CoreData


extension UserSettings {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSettings> {
        return NSFetchRequest<UserSettings>(entityName: "UserSettings")
    }
    
    @NSManaged public var daysBeforeNotification: Int16
    @NSManaged public var hourOfNotification: Int16
    @NSManaged public var minutesOfNotification: Int16
    @NSManaged public var isNotificationEnabled: Bool
    
}

extension UserSettings : Identifiable {
    
}
