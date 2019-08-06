//
//  ConflictChecker.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/5/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import Foundation

//Ideal place for the conflict checker algorithm.
func checkForEventConflicts(events: [EventModel]) -> [EventModel] {
    
    /*
     The gist of the problem is to find meetings that are conflicting to each other and somehow indicate the conflicting events on the UI.
     
     My current solution has limitations and is not perfect and doesn't cover some edge cases.
     
     Need help in writing a new algorithm or refining my implementation to solve this problem. (I did find multiple implementations of this problem in Java but nothing in Swift so far.)
     
     Some Java references - https://www.google.com/url?sa=t&rct=j&q=&esrc=s&source=web&cd=2&cad=rja&uact=8&ved=2ahUKEwjknPnc3O7jAhVyT98KHWzgCoQQFjABegQIBRAB&url=http%3A%2F%2Fkarmaandcoding.blogspot.com%2F2012%2F01%2Ffind-all-conflicting-appointments-from.html&usg=AOvVaw2d0-Gl5IfKGQYuGvwK9319
     
     Some other references -
     If you sort by start times then for each event(current event), do a binary search to find the largest start time (last conflicting event) which is less than current events end time. All the events between current event and last conflicting event is conflicting.
     */
    
    // Sorting events based on start date.
    var sortedEvents = events.sorted()
    
    // Get the events count
    let eventsCount = sortedEvents.count
    
    // Using Binary search as a base this logic checks for date range overlaps.
    for (index, event) in sortedEvents.enumerated() {
        var low = index + 1
        var high = eventsCount - 1
        let endTime = parseDate(event.end!)
        
        while (low <= high) {
            let mid = Int(floor(Float((low + high) / 2)))
            
            if (endTime > parseDate(sortedEvents[mid].start!)) && (mid+1 < eventsCount) && (endTime < parseDate(sortedEvents[mid+1].start!)) {
                low = mid
                break
            } else if (endTime > parseDate(sortedEvents[mid].start!)) {
                low = mid + 1
            } else {
                high = mid - 1
            }
        }
        
        low = low > high ? high : low
        // This loop is for getting the conflicting index.
        for k in stride(from: index+1, through: min(low, eventsCount), by: 1) {
            if (k == index) {
                continue;
            }
            sortedEvents[k].isConflicting = true
        }
        
    }
    
    
    return sortedEvents
    
    
}



