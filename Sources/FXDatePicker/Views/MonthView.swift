////
//MonthView.swift
//DatePickerExample
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
public struct MonthView: View {
    @Binding var displayedMonth: Date
    @Binding var selectedDate: Date
    let specialDates: [SpecialDate]
    
    @Environment(\.datePickerTheme) private var theme
    @Environment(\.calenderType) private var calenderType
    @Environment(\.layoutDirection) private var layoutDirection
    
    let calendar: Calendar
    
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
    
    public var body: some View {
        VStack {
            HStack {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .frame(maxWidth: .infinity)
                        .font(.caption)
                        .foregroundColor(theme.main.daysName)
                }
            }
            
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: 7)) {
                ForEach(0..<(numberOfRows * 7), id: \.self) { index in
                    gridCellView(at: index)
                }
            }
        }
    }
    
    
    
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
                    calendar: calendar)
            .onTapGesture { self.selectedDate = date }
        }
        else {
            Text("").frame(height: 50)
        }
    }
    
    
    
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
    
    
    private var totalCells: Int { 6 * 7 } // 6 rows, 7 columns
    
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
            switch specialDate.dateType {
            case .image(let imageType):
                return imageType.dateString.dateFromString(calendar: calendar) == date
            case .sfSymbols(let sfSymbolsType):
                return sfSymbolsType.dateString.dateFromString(calendar: calendar) == date
            }
        })
    }
    
}
