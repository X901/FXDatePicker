////
//File.swift
//
//
//Created by Basel Baragabah on 11/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import Foundation

extension Calendar {
    public func findCurrentDateIndex(dateRange: [Date], selectedDate: Date?) -> Int {
        // Find the index of the current date
        guard let selectedDate = selectedDate else {return 0}
        let currentDate = self.startOfDay(for: selectedDate)
        return dateRange.firstIndex(where: { self.isDate($0, equalTo: currentDate, toGranularity: .day) }) ?? (dateRange.count - 1)
    }
}
