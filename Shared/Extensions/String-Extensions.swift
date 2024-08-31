//
//  String-Extensions.swift
//  Cronica
//
//  Created by Alexandre Madeira on 03/02/23.
//

import Foundation

extension String {
    static let releaseDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = .current
        formatter.formatOptions = .withFullDate
        return formatter
    }()
    func convertStringToDate() -> Date? {
        let formatter = DateFormatter()
        formatter.dateStyle = .full
        formatter.timeStyle = .short
        formatter.timeZone = .current
        formatter.dateFormat = "MM-dd-yyyy HH:mm"
        return formatter.date(from: self)
    }
    /// Convert dates with format y MM dd
    func toDate() -> Date? {
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateFormat = "y,MM,dd"
        return formatter.date(from: self)
    }
}

extension String? {
    /// Format an string using an ISO8601 formatter.
    /// - Returns: If the string is valid, it will return a string with full date.
    func toFormattedStringDate() -> String? {
        if let value = self {
            let date = String.releaseDateFormatter.date(from: value)
            if let date {
                return date.convertDateToString()
            }
        }
        return nil
    }
}
