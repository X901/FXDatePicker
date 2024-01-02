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
            
            MonthView(displayedMonth: $displayedMonth,
                      selectedDate: $selectedDate,
                      specialDates: specialDates,
                      calendar: calendar, 
                      hideMarkers: hideMarkers)
        }
        .padding()
        .background(theme.main.backgroundColor)
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

public extension FXDatePickerView {
    
    func hideMarkers(_ show: Bool = true) -> FXDatePickerView {
        var fxDatePicker = self
        fxDatePicker.hideMarkers = show
        return fxDatePicker
    }
    
}
