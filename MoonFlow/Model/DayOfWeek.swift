//
//  DayOfWeek.swift
//  MoonFlow
//
//  Created by Camille on 21/3/24.
//

import Foundation

enum DayOfWeek: Int {
    case monday = 2
    case tuesday = 3
    case wednesday = 4
    case thursday = 5
    case friday = 6
    case saturday = 7
    case sunday = 1
    
    var dayIndex: Int {
        return self.rawValue
    }
    
    init?(dayIndex: Int) {
        self.init(rawValue: dayIndex)
    }
}
