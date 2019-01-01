//
//  Date+Extras.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/20/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import Foundation

extension Date {

    func readable() -> String {
        
        let dateformatter = DateFormatter()
        
        dateformatter.dateStyle = DateFormatter.Style.medium
        
        let now = dateformatter.string(from: NSDate() as Date)
        
        return now
    }
}
