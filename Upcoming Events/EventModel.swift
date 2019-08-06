//
//  EventModel.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/3/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import Foundation

struct EventModel: Codable, Comparable {
    let title, start, end: String?
    var isConflicting: Bool = false // Added extra parameter for indicating conflict.
    
    
    //Method used for enabling sort method on EventModel in ascending order
    static func < (lhs: EventModel, rhs: EventModel) -> Bool {
        return parseDate(lhs.start!) < parseDate(rhs.start!)
    }
}

// Coding keys for only keys in json
extension EventModel {
    
    enum CodingKeys: String, CodingKey {
        case title
        case start
        case end
    }
}

//Method that parses mock.json file to the data model
func loadJsonToEventModel() -> [EventModel]? {
    if let url = Bundle.main.url(forResource: "mock", withExtension: "json") {
        do {
            let data = try Data(contentsOf: url)
            let decoder = JSONDecoder()
            let jsonData = try decoder.decode(Array<EventModel>.self, from: data)
            return jsonData
        } catch {
            print("error:\(error)")
        }
    }
    return nil
}

//Method to convert the date from String type to Date type
func parseDate(_ str : String) -> Date {
    let dateFormat = DateFormatter()
    dateFormat.dateFormat = "MMMM d, yyyy h:mm a"
    return dateFormat.date(from: str)!
}
