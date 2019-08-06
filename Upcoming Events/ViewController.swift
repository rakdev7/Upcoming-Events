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
    var eventModelItemsFromJson: [EventModel] = [EventModel]()
    var sections = [SectionItem]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupTableView()
    }
}

struct SectionItem: Comparable {
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
        let groups = Dictionary(grouping: self.eventModelItemsFromJson) { (event) -> Date in
            return eachDayForSection(date: parseDate(event.start!))
        }
        self.sections = groups.map(SectionItem.init(sectionDate:rowItems:)).sorted()
        checkForConflicts()
    }
    
    func eachDayForSection(date : Date) -> Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        return calendar.date(from: components)!
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let section = self.sections[section]
        return section.rowItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sections.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
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
        
        if indexPath.row == 0 {
            cell.conflictLabel.text = "This is a conflict!"
            cell.conflictLabel.isHidden = false
        }
        return cell
    }
    
}

extension ViewController {
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

