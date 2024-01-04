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
    private var disableSwipe: Bool = false
    private var hideDatePicker: Bool = false

    @State private var dateRange: [Date] = []
    
    @State private var shouldUpdateView: Bool = false
    
    @State private var openShowSelectedMonths: Bool = false
    
    @State private var arrowRotation: Double = 0
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
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
                
                monthTitleView()

                Spacer()
                
                if !openShowSelectedMonths {
                    
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
            }
            .padding(.horizontal, 12)
            .frame(height: 40)
            
            VStack {
                if !openShowSelectedMonths {
                    HStack {
                        ForEach(daysOfWeek, id: \.self) { day in
                            Text(day)
                                .frame(maxWidth: .infinity)
                                .font(.caption)
                                .foregroundColor(theme.main.daysName)
                        }
                    }
                }
                
                SwipeView(dateRange: $dateRange, displayedMonth: $displayedMonth, isDisable: disableSwipe) {
                    
                    if disableSwipe {
                        MonthView(displayedMonth: $displayedMonth,
                                  selectedDate: $selectedDate,
                                  specialDates: specialDates,
                                  calendar: calendar,
                                  hideMarkers: hideMarkers)
                    } else {
                        ForEach($dateRange, id: \.self) { $month in
                            MonthView(displayedMonth: $month,
                                      selectedDate: $selectedDate,
                                      specialDates: specialDates,
                                      calendar: calendar,
                                      hideMarkers: hideMarkers)
                            .tag(month)
                        }
                    }
                    
                }
                .id(shouldUpdateView)
                .frame(height: openShowSelectedMonths != true ? (hideMarkers ? 280 : 320) : (hideMarkers ? 300 : 340))
                .overlay(
                    
                    openShowSelectedMonths ? SelectMonthPickerView(selectedDate: $selectedDate, calendar: calendar, calenderType: calenderType)
                        .onChange(of: selectedDate, perform: { value in
                            displayedMonth = value
                            setupCurrentDate()
                        })
                    
                    : nil
                    
                    
                    
                    , alignment: .center)
                
            }
        }
        .padding()
        .background(theme.main.backgroundStyle)
        .onAppear {
            setupCurrentDate()
        }
        .onChange(of: displayedMonth) { newMonth in
            updateDateRangeIfNeeded(for: newMonth)
        }
        
    }
    
}

public extension FXDatePickerView {
    
    func hideMarkers(_ hide: Bool = true) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.hideMarkers = hide
        return fxDatePicker
    }
    
    func disableSwipe(_ disable: Bool = true) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.disableSwipe = disable
        return fxDatePicker
    }
    
    func hideDatePicker(_ hide: Bool = true) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.hideDatePicker = hide
        return fxDatePicker
    }
    
    private func setupCurrentDate() {
        // load 6 years when DatePicker appear
        let startRange = calendar.date(byAdding: .year, value: -6, to: displayedMonth)!
        let endRange = calendar.date(byAdding: .year, value: 6, to: displayedMonth)!
        dateRange = generateMonths(start: startRange, end: endRange)
    }
    
    // Needed for Swipe feature to load more Months
    private func updateDateRangeIfNeeded(for month: Date) {
        let monthStart = month
        
        // Check and extend the end of the range
        if let lastMonth = dateRange.last, monthStart > calendar.date(byAdding: .month, value: -6, to: lastMonth)! {
            let newEnd = calendar.date(byAdding: .month, value: 6, to: lastMonth)!
            let newMonths = generateMonths(start: lastMonth, end: newEnd).filter { !dateRange.contains($0) }
            dateRange.append(contentsOf: newMonths)
            dateRange = Array(Set(dateRange)).sorted() // Remove duplicates and sort
            print("Extended end of range. New range: \(dateRange)")
            shouldUpdateView.toggle()
            
        }
        
        // Check and extend the start of the range
        if let firstMonth = dateRange.first, monthStart < calendar.date(byAdding: .month, value: 6, to: firstMonth)! {
            let newStart = calendar.date(byAdding: .month, value: -6, to: firstMonth)!
            let newMonths = generateMonths(start: newStart, end: firstMonth).filter { !dateRange.contains($0) }
            dateRange.insert(contentsOf: newMonths, at: 0)
            dateRange = Array(Set(dateRange)).sorted() // Remove duplicates and sort
            print("Extended start of range. New range: \(dateRange)")
            shouldUpdateView.toggle()
            
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
    
   @ViewBuilder func monthTitleView() -> some View {
       if hideDatePicker {
           Text(getMonthName(from: displayedMonth))
               .toBold()
               .foregroundColor(theme.main.monthTitle)
       } else {
           
           Button(action: {
               withAnimation {
                   arrowRotation = arrowRotation == 0 ? 90 : 0
                   openShowSelectedMonths.toggle()
               }
               
           }, label: {
               
               HStack(spacing: 5) {
                   
                   Text(getMonthName(from: displayedMonth))
                       .toBold()
                       .foregroundColor(theme.main.monthTitle)
                   
                   Image(systemName: layoutDirection == .rightToLeft ? "chevron.left" : "chevron.right" )
                       .font(.system(size: 12))
                       .toBold()
                       .rotationEffect(.degrees(arrowRotation))
                       .foregroundColor(theme.main.accentColor)
               }
           })
       }

    }
    
}
