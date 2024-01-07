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
    @Binding var displayedMonth: Date
    @Binding var dateRange: [Date]
    
    init(dateRange: Binding<[Date]> ,displayedMonth: Binding<Date>, isDisable: Bool, @ViewBuilder content: @escaping () -> Content) {
        self._dateRange = dateRange
        self._displayedMonth = displayedMonth
        self.isDisable = isDisable
        self.content = content
    }

    var body: some View {
        Group {
            if isDisable == false {
                TabView(selection: $displayedMonth) {
                        content()
                    
                }
                .tabViewStyle(.page(indexDisplayMode: .never))

            } else {
                content()
            }
        }
    }
}
