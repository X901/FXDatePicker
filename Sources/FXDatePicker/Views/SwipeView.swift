////
//SwipeView.swift
//
//
//Created by Basel Baragabah on 03/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

internal struct SwipeView<Content: View>: View {
    let content: () -> Content
    var isDisable: Bool
    var calendar: Calendar
    
    @Binding var displayedMonth: Date
    @Binding var dateRange: [Date]
    @Binding var selectedIndex: Int
    
    init(dateRange: Binding<[Date]> ,displayedMonth: Binding<Date>, selectedIndex: Binding<Int> , calendar: Calendar, isDisable: Bool, @ViewBuilder content: @escaping () -> Content) {
        self._dateRange = dateRange
        self._displayedMonth = displayedMonth
        self.isDisable = isDisable
        self.content = content
        self.calendar = calendar
        self._selectedIndex = selectedIndex

    }

    var body: some View {
        Group {
            if isDisable == false {
                TabView(selection: $selectedIndex) {
                        content()
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .onAppear {
                    let selectedDate = calendar.startOfDay(for: Date())
                    print("selectedDate: \(selectedDate)")
                    selectedIndex = findCurrentDateIndex(calendar: calendar, dateRange: dateRange, selectedDate: selectedDate)
                }
                .onChange(of: selectedIndex) { newValue in
                    displayedMonth = dateRange[newValue]
                }
            } else {
                content()
            }
        }
    }

}

