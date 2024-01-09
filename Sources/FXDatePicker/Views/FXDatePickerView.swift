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
    private var calenderType: CalenderType = .gregorian
    @Environment(\.layoutDirection) private var layoutDirection
    
    private var hideMarkers: Bool = false
    private var disableSwipe: Bool = false
    private var hideDatePicker: Bool = false
    
    @State private var dateRange: [Date] = []
    
    @State private var shouldUpdateView: Bool = false
    
    @State private var openShowSelectedMonths: Bool = false
    
    @State private var arrowRotation: Double = 0
    
    var closeRange: ClosedRange<Date> = Date()...Date()
    
    private var daysOfWeek: [String] {
        return calendar.shortWeekdaySymbols
    }
    
    private var calendar: Calendar {
        switch calenderType {
        case .gregorian:
            var calendar = Calendar(identifier: .gregorian)
            calendar.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
            return calendar
            
        case .hijri(let hijriType):
            var calendar: Calendar
            switch hijriType {
            case .islamicUmmAlQura:
                calendar = Calendar(identifier: .islamicUmmAlQura)
            case .islamic:
                calendar = Calendar(identifier: .islamic)
            case .islamicCivil:
                calendar = Calendar(identifier: .islamicCivil)
            case .islamicTabular:
                calendar = Calendar(identifier: .islamicTabular)
            }
            calendar.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
            
            return calendar
        }
    }
    
    private var canMoveToPreviousMonth: Bool {
        guard let minDate = dateRange.first else { return false }
        return calendar.date(byAdding: .month, value: -1, to: displayedMonth) ?? Date() >= minDate
    }
    
    private var canMoveToNextMonth: Bool {
        guard let maxDate = dateRange.last else { return false }
        return calendar.date(byAdding: .month, value: 1, to: displayedMonth) ?? Date() <= maxDate
    }
    
    // MARK:- with specialDates
    public init(selectedDate: Binding<Date>, specialDates: [SpecialDate]) {
        self._selectedDate = selectedDate
        self.specialDates = specialDates
        
        self.closeRange = Date.distantPast...Date.distantFuture
        
        self.displayedMonth = closeRange.lowerBound
    }
    
    
    public init(selectedDate: Binding<Date>, specialDates: [SpecialDate], in closeReange: ClosedRange<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = specialDates
        self.closeRange = closeReange
        
        self.displayedMonth = closeRange.lowerBound
    }
    
    public init(selectedDate: Binding<Date>, specialDates: [SpecialDate], in range: PartialRangeFrom<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = specialDates
        
        let end = calendar.date(byAdding: .year, value: 100, to: Date()) ?? Date()

        self.closeRange = range.lowerBound...end
        
        self.displayedMonth = closeRange.lowerBound
    }
    
    public init(selectedDate: Binding<Date>, specialDates: [SpecialDate], in range: PartialRangeThrough<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = specialDates
        
        let start = calendar.date(byAdding: .year, value: -100, to: Date()) ?? Date()
        
        self.closeRange = start...range.upperBound
        
        self.displayedMonth = closeRange.upperBound
    }
    
    
    // MARK:- without specialDates
    public init(selectedDate: Binding<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = []
        
        let start = calendar.date(byAdding: .year, value: -100, to: Date()) ?? Date()
        let end = calendar.date(byAdding: .year, value: 100, to: Date()) ?? Date()

        self.closeRange = start...end
        
        self.displayedMonth = closeRange.lowerBound
        self.hideMarkers = true
    }
    
    
    public init(selectedDate: Binding<Date>, in closeReange: ClosedRange<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = []
        self.closeRange = closeReange
        
        self.displayedMonth = closeRange.lowerBound
    }
    
    public init(selectedDate: Binding<Date>, in range: PartialRangeFrom<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = []
        
        let end = calendar.date(byAdding: .year, value: 100, to: Date()) ?? Date()
  
        self.closeRange = range.lowerBound...end
        
        self.displayedMonth = closeRange.lowerBound
        self.hideMarkers = true
        
    }
    
    public init(selectedDate: Binding<Date>, in range: PartialRangeThrough<Date>) {
        self._selectedDate = selectedDate
        self.specialDates = []
        
        let start = calendar.date(byAdding: .year, value: -100, to: Date()) ?? Date()

        self.closeRange = start...range.upperBound
        
        self.displayedMonth = closeRange.upperBound
        self.hideMarkers = true
        
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
                            .foregroundColor(canMoveToPreviousMonth ? theme.main.accentColor : Color.gray)
                        
                    }
                    .padding(.horizontal)
                    .disabled(!canMoveToPreviousMonth)
                    
                    Button(action: { changeMonth(by: 1) }) {
                        Image(systemName: layoutDirection == .leftToRight ? "chevron.right" : "chevron.left")
                            .toBold()
                            .foregroundColor(canMoveToNextMonth ? theme.main.accentColor : Color.gray)
                    }
                    .disabled(!canMoveToNextMonth)
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
                    
                    openShowSelectedMonths ? SelectMonthPickerView(selectedDate: $selectedDate, calendar: calendar, calenderType: calenderType, closeRange: closeRange)
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
            updateDateRangeIfNeeded(for: newMonth, limitDate: closeRange.upperBound)
        }
        
    }
    
}

public extension FXDatePickerView {
    
    func calenderType(_ calenderType: CalenderType = .gregorian) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.calenderType = calenderType
        return fxDatePicker
    }
    
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
        //displayedMonth = closeRange.lowerBound
        dateRange = generateMonths(start: displayedMonth, end: closeRange.upperBound)
    }
    
    private func updateDateRangeIfNeeded(for month: Date, limitDate: Date) {
        let monthStart = month
        
        let lastMonth = closeRange.upperBound
        
        // Extend the end of the range but not beyond the limitDate
        if monthStart > calendar.date(byAdding: .month, value: -6, to: lastMonth) ?? Date(),
           limitDate > lastMonth {
            
            let newEnd = min(calendar.date(byAdding: .month, value: 6, to: lastMonth) ?? Date(), limitDate)
            extendDateRange(from: lastMonth, to: newEnd)
        }
        
        let firstMonth = closeRange.lowerBound
        
        // Extend the start of the range but not beyond the limitDate
        if monthStart < calendar.date(byAdding: .month, value: 6, to: firstMonth) ?? Date(),
           limitDate < firstMonth {
            
            let newStart = max(calendar.date(byAdding: .month, value: -6, to: firstMonth) ?? Date(), limitDate)
            extendDateRange(from: newStart, to: firstMonth, atStart: true)
        }
    }
    
    private func extendDateRange(from start: Date, to end: Date, atStart: Bool = false) {
        let newMonths = generateMonths(start: start, end: end).filter { !dateRange.contains($0) }
        if atStart {
            dateRange.insert(contentsOf: newMonths, at: 0)
        } else {
            dateRange.append(contentsOf: newMonths)
        }
        dateRange = Array(Set(dateRange)).sorted()
        print("Extended date range. New range: \(dateRange)")
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
        guard let newMonth = calendar.date(byAdding: .month, value: increment, to: displayedMonth) else {
            print("Failed to calculate new month")
            return
        }
        
        // Assuming dateRange is sorted, get the minimum and maximum dates
        guard let minDate = dateRange.first, let maxDate = dateRange.last else {
            print("Date range is empty")
            return
        }
        
        // Check if the newMonth is within the dateRange
        if newMonth >= minDate && newMonth <= maxDate {
            displayedMonth = newMonth
            
        } else {
            print("New month is outside the date range")
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
