//
//  SectionItem.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/6/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import Foundation

struct SectionItem: Comparable {
    //Method used for enabling sort method on Section Item in ascending order
    static func < (lhs: SectionItem, rhs: SectionItem) -> Bool {
        return lhs.sectionDate < rhs.sectionDate
    }
    
    var sectionDate: Date
    var rowItems: [EventModel]
}

//This function will give the day of the event so that we can map it to a particular section
func eachDayForSection(date : Date) -> Date {
    let calendar = Calendar.current
    let components = calendar.dateComponents([.year, .month, .day], from: date)
    return calendar.date(from: components)!
}
