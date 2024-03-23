//
//  UserInfos+CoreDataProperties.swift
//  MoonFlow
//
//  Created by Camille on 22/3/24.
//
//

import Foundation
import CoreData


extension UserInfos {
    
    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserInfos> {
        return NSFetchRequest<UserInfos>(entityName: "UserInfos")
    }
    
    @NSManaged public var name: String?
    @NSManaged public var isReady: Bool
    
}

extension UserInfos : Identifiable {
    
}
