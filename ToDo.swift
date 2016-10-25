//
//  ToDo.swift
//  ToDoListSKC
//
//  Created by Sean Crowl on 10/24/16.
//  Copyright © 2016 Interapt. All rights reserved.
//

import Foundation
import UIKit

class ToDo: NSObject, NSCoding {
    var title = ""
    var date = Date()
    var category = ""
    var completed = ""
    var dueDate = ""
    
    let titleKey = "title"
    let dateKey = "date"
    let categoryLabelKey = "category"
    let completedKey = "completed"
    let dueDateKey = "dueDate"
    
    var dateString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        return dateFormatter.string(from: date)
    }
    
    override init() {
        super.init()
        
    }
    
    init(title: String) {
        self.title = title
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.title = aDecoder.decodeObject(forKey: titleKey) as! String
        self.date = aDecoder.decodeObject(forKey: dateKey) as! Date
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(title, forKey: titleKey)
        aCoder.encode(date, forKey: dateKey)
    }
}

