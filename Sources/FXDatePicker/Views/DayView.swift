////
//DayView.swift
//FXDatePicker
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
internal struct DayView: View {
    let date: Date?
    let isSelected: Bool
    let isBeforeToday: Bool
    let isToday: Bool
    let specialDate: SpecialDate?
    let hideMarkers: Bool

    private let imageSize: CGFloat = 25
    let calendar: Calendar
    
    @Environment(\.calenderType) private var calenderType
    @Environment(\.datePickerTheme) private var theme
    
    internal var body: some View {
        VStack(spacing: 0) {
            if let date = date {
                Text(dayFormatter.string(from: date))
                    .foregroundColor(isSelected ? 
                                     (isToday ? .white : theme.main.accentColor) :
                                     (isBeforeToday ? theme.main.previousDaysNumber :
                                     (isToday ? theme.main.accentColor : theme.main.daysNumbers)
                                     ))
                    .font(.system(size: 20))
                    .toBold(isSelected || isToday)
                    .frame(width: 30, height: 30)
                    .padding(.horizontal, 8)
                    .background(isSelected ? isToday ? theme.main.accentColor : theme.main.accentColor.opacity(0.2) : Color.clear)
                    .cornerRadius(20)
            }
            
            if !hideMarkers {
                ZStack {
                    
                        if let specialDate = specialDate {
                            specialDateImage(specialDate)
                                .frame(height: imageSize)
                                .padding(.vertical, 10)
                        }
                    
                    
                }
                .frame(height: imageSize + 10)
            }
        }
        .frame(height: hideMarkers == false ? 50 : 40)
    }
    
}

extension DayView {
    
    @ViewBuilder func specialDateImage(_ specialDate: SpecialDate) -> some View {
        switch specialDate.dateType {
        case .image(let imageType):
            
            Image(imageType.imageName)
                .resizable()
                .scaledToFit()
            
        case .sfSymbols(let sfSymbolsType):
            Image(systemName: sfSymbolsType.imageName)
                .foregroundColor(sfSymbolsType.color)
            
        }
    }
    
    
    private var dayFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = calendar
        formatter.dateFormat = "d"
        formatter.locale = Locale(identifier: Locale.preferredLanguages.first ?? "ar")
        return formatter
    }
}
