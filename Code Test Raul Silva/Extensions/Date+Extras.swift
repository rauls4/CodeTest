//
//  Date+Extras.swift
//  Code Test Raul Silva
//
//  Created by Raul Silva on 12/20/18.
//  Copyright © 2018 Silva. All rights reserved.
//

import Foundation

extension Date {
    struct Formatter {
        static let dateFormatter = DateFormatter()
    }
    
    var shortDate: String {
         Formatter.dateFormatter.dateFormat = "MMM dd, yyyy"
       return Formatter.dateFormatter.string(from: self)
    }
}
