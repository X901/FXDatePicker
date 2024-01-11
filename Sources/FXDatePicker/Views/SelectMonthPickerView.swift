////
//SelectMonthPickerView.swift
//
//
//Created by Basel Baragabah on 03/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

internal struct SelectMonthPickerView: View {
    @Environment(\.datePickerTheme) private var theme
    let calendar: Calendar
    let calenderType: CalenderType
    let closeRange: ClosedRange<Date>
    @Binding var selectedDate: Date

    @State private var pickerData: [[String]] = [[]]
    @State private var selections: [Int] = []

    private var years: [Int] {
        let startYear = calendar.component(.year, from: closeRange.lowerBound)
        let endYear = calendar.component(.year, from: closeRange.upperBound)
        return Array(startYear...endYear)
    }

    init(selectedDate: Binding<Date>, calendar: Calendar, calenderType: CalenderType, closeRange: ClosedRange<Date>) {
        self.calendar = calendar
        self._selectedDate = selectedDate
        self.calenderType = calenderType
        self.closeRange = closeRange

        let currentYear = calendar.component(.year, from: selectedDate.wrappedValue)
        let currentMonth = calendar.component(.month, from: selectedDate.wrappedValue) - 1
        let yearIndex = years.firstIndex(of: currentYear) ?? 0

        let initialMonths = getMonths(for: currentYear)
        self._pickerData = State(initialValue: [years.map { String($0) }, initialMonths])
        self._selections = State(initialValue: [yearIndex, currentMonth])
    }

    var body: some View {
        ZStack {
            FXBackgroundView(background: theme.main.backgroundStyle)

            FXPickerView(data: $pickerData, selections: $selections, textColor: UIColor(theme.main.monthTitle))
                .onChange(of: selections[0]) { yearIndex in
                    let selectedYear = years[yearIndex]
                    pickerData[1] = getMonths(for: selectedYear)
                }
                .onChange(of: selections) { value in
                    updateSelectedDate(with: value)
                }
        }
    }

    private func getMonths(for year: Int) -> [String] {
        let isStartYear = year == calendar.component(.year, from: closeRange.lowerBound)
        let isEndYear = year == calendar.component(.year, from: closeRange.upperBound)

        if isStartYear {
            let firstMonth = calendar.component(.month, from: closeRange.lowerBound)
            return Array(calendar.monthSymbols.dropFirst(firstMonth - 1))
        } else if isEndYear {
            let lastMonth = calendar.component(.month, from: closeRange.upperBound)
            return Array(calendar.monthSymbols.prefix(lastMonth))
        } else {
            return calendar.monthSymbols
        }
    }

    func updateSelectedDate(with selections: [Int]) {
        var components = DateComponents()
        components.year = years[selections[0]]
        components.month = selections[1] + 1
        components.day = calendar.component(.day, from: selectedDate)

        if let updatedDate = calendar.date(from: components), closeRange.contains(updatedDate) {
            selectedDate = updatedDate
        }
    }
}



#Preview {
    SelectMonthPickerView(selectedDate: .constant(Date()), calendar: Calendar.current, calenderType: .gregorian, closeRange: Date()...Date())
}
