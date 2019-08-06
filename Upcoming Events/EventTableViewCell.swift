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
        self.titleLabel.text = ""
        self.startLabel.text = ""
        self.endLabel.text = ""
        self.conflictLabel.text = ""
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)!
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        conflictLabel.isHidden = true
    }
    
}
