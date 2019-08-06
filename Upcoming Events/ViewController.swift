//
//  ViewController.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/3/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var eventsTableView: UITableView!
    //variable to hold Event items parsed from mock.json file.
    var eventModelItemsFromJson: [EventModel] = [EventModel]()
    //variable to hold sections that contain event items grouped by date.
    var sections = [SectionItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        //This will setup the UI for the table view
        setupTableView()
    }
}

struct SectionItem: Comparable {
    //Method used for enabling sort method on Section Item in ascending order
    static func < (lhs: SectionItem, rhs: SectionItem) -> Bool {
        return lhs.sectionDate < rhs.sectionDate
    }
    
    var sectionDate: Date
    var rowItems: [EventModel]
}

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func setupTableView() {
        eventsTableView.delegate = self
        eventsTableView.dataSource = self
        eventModelItemsFromJson = loadJsonToEventModel() ?? [EventModel]()
        
        //creating sections by creating groups of events using event date.
        let groups = Dictionary(grouping: self.eventModelItemsFromJson) { (event) -> Date in
            return eachDayForSection(date: parseDate(event.start!))
        }
        self.sections = groups.map(SectionItem.init(sectionDate:rowItems:)).sorted()
        //TODO: Function to give the list of conflicts in our events array and use this to setup the `This is a conflict label on the UI`
        checkForConflicts()
    }
    
    //This function will give the day of the event so that we can map it to a particular section
    func eachDayForSection(date : Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rowItems.count //Returning the number of events in each section
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count //Basically the number of days in our events array
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        //Giving a title to each section which will be the Date of the events in a given date
        let startDate = self.sections[section].sectionDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: startDate)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) ->
        UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "EventTableViewCellIdentifier") as? EventTableViewCell
            else {
                return UITableViewCell()
            }
        let section = self.sections[indexPath.section]
        let sortedRowItems = section.rowItems.sorted()
        let rowItem = sortedRowItems[indexPath.row]
        cell.titleLabel.text = rowItem.title
        cell.startLabel.text = rowItem.start
        cell.endLabel.text = rowItem.end
            
        //TODO: The below if condition should be replaced with the Algorithmic logic which identifies the conflicting cells
        //This is temporary and only is used to check if I can trigger the conflict label to ON state on any given cell.
        if indexPath.row == 0 {
            cell.conflictLabel.text = "This is a conflict!"
            cell.conflictLabel.isHidden = false
        }
        return cell
    }
    
}

extension ViewController {
    
    //This algorithm currently has a limitation in that - it only checks for consecutive elements for conflicts. It ideally should check for all events in a given day.
    func checkForConflicts() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d, h: mm"
        let sorted = self.eventModelItemsFromJson.sorted()
            for each in 0..<sorted.count - 1 {
                let firstStart = parseDate(sorted[each].start!)
                let nextStart = parseDate(sorted[each + 1].start!)
                let firstEnd = parseDate(sorted[each].end!)
                let nextEnd = parseDate(sorted[each + 1].end!)
                if ((firstStart < nextEnd) && (firstEnd > nextStart)) {
                    print("conflict \(dateFormatter.string(from: nextStart)) \(dateFormatter.string(from: nextEnd))")
                }
            }
        }
}

