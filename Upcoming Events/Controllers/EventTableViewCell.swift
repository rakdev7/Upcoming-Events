//
//  EventTableViewCell.swift
//  Upcoming Events
//
//  Created by Ravva, Rakesh on 8/3/19.
//  Copyright © 2019 MyOrg. All rights reserved.
//

import Foundation
import UIKit

class EventTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var endLabel: UILabel!
    @IBOutlet weak var conflictLabel: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        conflictLabel.isHidden = true
    }
    
    func configureCell(event: EventModel) -> EventTableViewCell {
        titleLabel.text = event.title
        startLabel.text = event.start
        endLabel.text = event.end
        
        if event.isConflicting {
            conflictLabel.text = "This is a conflict!"
            conflictLabel.isHidden = false
        }
        return self
    }
}
