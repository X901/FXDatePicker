////
//MonthView.swift
//FXDatePicker
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct MonthView: View {
    @Binding var displayedMonth: Date
    @Binding var selectedDate: Date
    let specialDates: [SpecialDate]
    
    @Environment(\.datePickerTheme) private var theme
    @Environment(\.calenderType) private var calenderType
    @Environment(\.layoutDirection) private var layoutDirection
    
    let calendar: Calendar
    let hideMarkers: Bool
    
    private var totalCells: Int { 6 * 7 } // 6 rows, 7 columns

    
    private var firstDayOfMonth: Date {
        calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) ?? Date()
    }
    
    private var firstDayOfWeekInMonth: Int {
        guard let firstDayOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: displayedMonth)) else {
            return 0
        }
        let weekday = calendar.component(.weekday, from: firstDayOfMonth)
        
        let offset = layoutDirection == .leftToRight ? (calendar.firstWeekday - 1) : (calendar.firstWeekday)
        return (weekday + 6 - offset) % 7
    }
    
    
    private var numberOfRows: Int {
        let totalDaysToShow = firstDayOfWeekInMonth + daysInMonth
        return (totalDaysToShow / 7) + (totalDaysToShow % 7 > 0 ? 1 : 0)
    }
    
    private var daysInMonth: Int {
        guard let range = calendar.range(of: .day, in: .month, for: displayedMonth) else {
            return 30
        }
        return range.count
    }
    
    private let totalMonthViewHeight: CGFloat = 300
    private let maxRows: Int = 6

    
    internal var body: some View {
        let rowHeight: CGFloat = (hideMarkers == false) ? 50 : 45
        let totalRowHeight = CGFloat(numberOfRows) * rowHeight
        let totalPaddingHeight = totalMonthViewHeight - totalRowHeight
        let paddingPerRow = totalPaddingHeight / CGFloat(maxRows - 2)

            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7), spacing: paddingPerRow) {
                ForEach(0..<(numberOfRows * 7), id: \.self) { index in
                    gridCellView(at: index)
                }
            }
            .frame(height: totalMonthViewHeight)
    }    
}

extension MonthView {
    
    @ViewBuilder private func gridCellView(at index: Int) -> some View {
        let dayOffset = index - firstDayOfWeekInMonth
        if dayOffset >= 0 && dayOffset < daysInMonth {
            let date = getDateFor(day: dayOffset + 1)
            let specialDate = findSpecialDate(for: date)
            
            DayView(date: date,
                    isSelected: isSameDay(date1: selectedDate, date2: date),
                    isBeforeToday: isDateBeforeToday(date: date),
                    isToday: isToday(date: date),
                    specialDate: specialDate,
                    hideMarkers: hideMarkers,
                    calendar: calendar)
            .onTapGesture { self.selectedDate = date }
        }
        else {
            Text("").frame(height: 50)
        }
    }

        
    private func getDateFor(day: Int) -> Date {
        calendar.date(from: DateComponents(year: calendar.component(.year, from: displayedMonth), month: calendar.component(.month, from: displayedMonth), day: day))!
    }
    
    private func isDateBeforeToday(date: Date) -> Bool {
        calendar.startOfDay(for: date) < calendar.startOfDay(for: Date())
    }
    
    private func isToday(date: Date) -> Bool {
        calendar.isDateInToday(date)
    }
    
    private func isSameDay(date1: Date, date2: Date) -> Bool {
        calendar.isDate(date1, inSameDayAs: date2)
    }
    
    
    private func findSpecialDate(for date: Date) -> SpecialDate? {
        specialDates.first(where: { specialDate in
            
            specialDate.dateString.dateFromString(calendar: calendar) == date
        })
    }
}
