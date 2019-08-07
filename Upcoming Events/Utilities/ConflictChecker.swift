//
//  ConflictChecker.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/5/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import Foundation

/*

 Description -
 This algorithm takes an input array of EventModel items which are upcoming events from the mock.json file and sorts them in ascending order to be fed as input for binary search.

 Starting with the end time of first event in the array, a binary search is performed on the rest of the array to find a conflicting event (Any event whose start time is less than the end time of the first event).
 
 If a conflict is found, we break out of the search and modify the isConflicting flag on the EventModel and move on to the next event in the array and so on.
 
 The output array will contain an array of EventModel items with updated state of isConflicting parameter for each event.
 
 Assumptions -
 One assumption I've made is that when looking for conflicting events the first event in chronological order will be a `normal`(Not a conflict) event and the successive events that conflict with the before set `normal` event are marked as conflicts.
 
 Runtime complexity analysis-
 The below algorithm uses binary search[O(logn)] and looping through all the elements[O(n)] in the `events` array. The time complexity of this algorithm is O(nlogn).

 */

func checkForEventConflicts(events: [EventModel]) -> [EventModel] {
    
    // Sorting events based on start date.
    var sortedEvents = events.sorted()
    
    // Get the events count
    let eventsCount = sortedEvents.count
    
    // Using Binary search as a base this logic checks for date range overlaps.
    for (index, event) in sortedEvents.enumerated() {
        var low = index + 1
        var high = eventsCount - 1
        let endTime = getDateFromString(event.end!)
        
        while (low <= high) {
            let mid = Int(floor(Float((low + high) / 2)))
            
            if (endTime > getDateFromString(sortedEvents[mid].start!)) && (mid+1 < eventsCount) && (endTime < getDateFromString(sortedEvents[mid+1].start!)) {
                low = mid
                break
            } else if (endTime > getDateFromString(sortedEvents[mid].start!)) {
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
