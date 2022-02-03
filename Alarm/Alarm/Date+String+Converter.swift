//
//  Date+String+Converter.swift
//  Alarm
//
//  Created by jiniz.ll on 2022/01/10.
//

import Foundation

enum DateFormats: String {
    case displayTime = "a h:mm"
    case storedTime = "HH:mm"
}

extension Date {
    
    func convertToString(format: DateFormats) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_kr")
        formatter.timeZone = TimeZone(abbreviation: "KST")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
}

extension String {
    
    func convertToDate() -> Date {
        let dateString: String = self
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = DateFormats.displayTime.rawValue
        dateFormatter.timeZone = NSTimeZone(name: "KST") as TimeZone?

        let date: Date = dateFormatter.date(from: dateString)!
        return date
    }
}
