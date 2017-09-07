//
//  Date.swift
//  DiaryApp
//
//  Created by Ty Schenk on 9/4/17.
//  Copyright © 2017 Ty Schenk. All rights reserved.
//

import Foundation

enum dateTypes {
    case dateMonth
    case dateInt
}

func getCurrentDate(format: dateTypes) -> String {
    var setupDate: String = ""
    switch format {
    case .dateInt:
        let date = Date()
        let calendar = Calendar.current
        
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        setupDate = "\(month)/\(day)/\(year)"
    case .dateMonth:
        let date = Date()
        let calendar = Calendar.current
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "LLLL"
        let month = dateFormatter.string(from: date)
        let year = calendar.component(.year, from: date)
        
        let dateComponents = calendar.component(.day, from: date)
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .ordinal
        let day = numberFormatter.string(from: dateComponents as NSNumber)
        
        setupDate = "\(month) \(day!) \(year)"
    }
    // Return Date String
    return setupDate
}

