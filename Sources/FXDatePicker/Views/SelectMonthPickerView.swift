////
//SwiftUIView.swift
//
//
//Created by Basel Baragabah on 03/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

struct SelectMonthPickerView: View {
    
    @Environment(\.datePickerTheme) private var theme
    let calenderType: CalenderType

    let calendar: Calendar
    @Binding var selectedDate: Date
    
    private var years: [Int] {
           switch calenderType {
           case .hijri:
               return Array(1300...1500)
           default:
               return Array(1900...2100)
           }
       }

    private var numberFormatter: NumberFormatter {
        let formatter = NumberFormatter()
        let currentLocale = Locale.current

        if currentLocale.languageCode == "ar" {
            formatter.locale = Locale(identifier: "ar")
        } else {
            formatter.locale = Locale(identifier: "en")
        }
        
        return formatter
    }
    
    private var months: [String]

    private var pickerData: [[String]] = [[]]
    @State private var selections: [Int] = []

    init(selectedDate: Binding<Date>, calendar: Calendar, calenderType: CalenderType) {
        self.calendar = calendar
        self._selectedDate = selectedDate
        self.months = calendar.monthSymbols
        self.calenderType = calenderType

        let currentYear = calendar.component(.year, from: selectedDate.wrappedValue)
        let currentMonth = calendar.component(.month, from: selectedDate.wrappedValue) - 1

        let yearStrings = years.map { numberFormatter.string(from: NSNumber(value: $0)) ?? "" }
        let monthStrings = months.map { String($0) }
        pickerData = [yearStrings, monthStrings]
        
        let yearIndex = years.firstIndex(of: currentYear) ?? 0
        self._selections = State(initialValue: [yearIndex, currentMonth])
    }

    
    var body: some View {
        ZStack {
            theme.main.backgroundColor
                .ignoresSafeArea()
            
            PickerView(data: self.pickerData,
                       selections: self.$selections,
                       textColor: UIColor(theme.main.monthTitle))
            .onChange(of: selections) { value in
                updateSelectedDate(with: value)
            }
        }
       
        
    }
}

extension SelectMonthPickerView {
    
    func updateSelectedDate(with selections: [Int]) {
        var components = DateComponents()
        
        let yearIndex = selections[0]
        let monthIndex = selections[1]
        let dayIndex = calendar.component(.day, from: selectedDate)

        components.year = years[yearIndex]
        components.month = monthIndex + 1

        let newDate = calendar.date(from: components)

        let newMonthRange = calendar.range(of: .day, in: .month, for: newDate!)

        // If the selected day does exist in the new month, it will be the default day of the month
        if dayIndex <= newMonthRange!.count {
            components.day = dayIndex
        } else {
            // If the selected day doesn't exist in the new month, default will move to the first day of the month
            components.day = 1
        }
        
        if let updatedDate = calendar.date(from: components) {
            selectedDate = updatedDate
        } else {
            print("Failed to create date")
        }
    }
}

#Preview {
    SelectMonthPickerView(selectedDate: .constant(Date()), calendar: Calendar.current, calenderType: .gregorian)
}
