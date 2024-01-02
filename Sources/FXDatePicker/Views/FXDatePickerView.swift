////
//CustomHijriDatePickerView.swift
//FXDatePicker
//
//Created by Basel Baragabah on 31/12/2023.
//Copyright © 2023 Basel Baragabah. All rights reserved.
//

import SwiftUI

public struct FXDatePickerView: View {
    @Binding var selectedDate: Date
    @State private var displayedMonth: Date = Date()
    var specialDates: [SpecialDate]
    
    @Environment(\.datePickerTheme) private var theme
    @Environment(\.calenderType) private var calenderType
    @Environment(\.layoutDirection) private var layoutDirection
    
    private var hideMarkers: Bool = false

    @State private var dateRange: [Date] = []

    private var calendar: Calendar {
        switch calenderType {
        case .gregorian:
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
            
            return calendar
            
        case .hijri:
            var calendar = Calendar(identifier: .islamicUmmAlQura)
            calendar.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
            return calendar
        }
    }
    
    
     public init(selectedDate: Binding<Date>, specialDates: [SpecialDate]) {
        self._selectedDate = selectedDate
        self.specialDates = specialDates
    }
  
    public var body: some View {

        VStack {
            HStack {
                Text(getMonthName(from: displayedMonth))
                    .toBold()
                    .foregroundColor(theme.main.monthTitle)
                
                Spacer()
                
                Button(action: { changeMonth(by: -1) }) {
                    Image(systemName: layoutDirection == .leftToRight ? "chevron.left" : "chevron.right")
                        .toBold()
                        .foregroundColor(theme.main.accentColor)
                }
                .padding(.horizontal)
                
                Button(action: { changeMonth(by: 1) }) {
                    Image(systemName: layoutDirection == .leftToRight ? "chevron.right" : "chevron.left")
                        .toBold()
                        .foregroundColor(theme.main.accentColor)
                }
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            
            TabView(selection: $displayedMonth) {
                ForEach(dateRange, id: \.self) { month in
                           MonthView(displayedMonth: .constant(month),
                                                           selectedDate: $selectedDate,
                                                           specialDates: specialDates,
                                                           calendar: calendar,
                                                           hideMarkers: hideMarkers)
                           .id(month)
                           .onChange(of: displayedMonth) { newMonth in
                                                  updateDateRangeIfNeeded(for: newMonth)
                                              }
                       }
                   }
            .tabViewStyle(.page(indexDisplayMode: .never))
                   .frame(height: 320)

        }
        .padding()
        .background(theme.main.backgroundColor)
        .onAppear {
            setupCurrentDate()
        }

    }

}

public extension FXDatePickerView {
    
    func hideMarkers(_ show: Bool = true) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.hideMarkers = show
        return fxDatePicker
    }
    
    private func setupCurrentDate() {
        let currentDate = Date()
        let startRange = calendar.date(byAdding: .year, value: -3, to: currentDate)!
        let endRange = calendar.date(byAdding: .year, value: 3, to: currentDate)!
        dateRange = generateMonths(start: startRange, end: endRange)
        displayedMonth = currentDate

    }
    
    private func updateDateRangeIfNeeded(for month: Date) {
        // Convert the dateRange array to a Set for efficient contains checking
        let dateSet = Set(dateRange)

        let monthIndex = dateRange.firstIndex(of: month) ?? 0
        let totalMonths = dateRange.count

        // Load more months at the start if near the beginning of the range
        if monthIndex < 3 {
            let newStart = calendar.date(byAdding: .year, value: -1, to: dateRange.first!)!
            // Generate new months up to the day before the first month in the range
            let newEnd = calendar.date(byAdding: .day, value: -1, to: dateRange.first!)!
            let newMonths = generateMonths(start: newStart, end: newEnd)

            // Append only new months that are not already in dateRange
            let filteredMonths = newMonths.filter { !dateSet.contains($0) }
            dateRange = filteredMonths + dateRange
        }

        // Load more months at the end if near the end of the range
        if monthIndex > totalMonths - 4 {
            // Generate new months starting the day after the last month in the range
            let newStart = calendar.date(byAdding: .day, value: 1, to: dateRange.last!)!
            let newEnd = calendar.date(byAdding: .year, value: 1, to: dateRange.last!)!
            let newMonths = generateMonths(start: newStart, end: newEnd)

            // Append only new months that are not already in dateRange
            let filteredMonths = newMonths.filter { !dateSet.contains($0) }
            dateRange += filteredMonths
        }
    }

    
    private func generateMonths(start: Date, end: Date) -> [Date] {
           var months: [Date] = []
           var currentDate = start

           while currentDate <= end {
               months.append(currentDate)
               currentDate = calendar.date(byAdding: .month, value: 1, to: currentDate)!
           }

           return months
       }



    func changeMonth(by increment: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: increment, to: displayedMonth) {
            displayedMonth = newMonth
        }
    }
    
    private func getMonthName(from date: Date) -> String {
        let formatter = monthFormatter
        return formatter.string(from: date)
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "MMMM yyyy"
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
        return formatter
    }
    
}
