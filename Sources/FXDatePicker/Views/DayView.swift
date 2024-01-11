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
    let closeRange: ClosedRange<Date>
    let isSelected: Bool
    let isBeforeToday: Bool
    let isToday: Bool
    let specialDate: SpecialDate?
    let hideMarkers: Bool
    
    private let imageSize: CGFloat = 25
    let calendar: Calendar
    
    @Environment(\.datePickerTheme) private var theme
    
    private var isInRange: Bool {
          guard let date = date else { return false }
          return closeRange.contains(date)
      }
    
    internal var body: some View {
        VStack(spacing: 0) {
            if let date = date {
                Text(dayFormatter.string(from: date))
                    .foregroundColor(calculateTextColor())
                    .font(.system(size: 20))
                    .toBold(isSelected || isToday)
                    .frame(width: 30, height: 30)
                    .padding(.horizontal, 8)
                    .background(isSelected ? isToday ? theme.main.accentColor : theme.main.accentColor.opacity(0.2) : Color.clear)
                    .cornerRadius(20)
                    .allowsHitTesting(isInRange)
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
    
//    private func calculateTextColor() -> Color {
//           if !isInRange {
//               return Color.gray
//           } else if isSelected {
//               return isToday ? .white : theme.main.accentColor
//           } else {
//               return isBeforeToday ? theme.main.previousDaysNumber : (isToday ? theme.main.accentColor : theme.main.daysNumbers)
//           }
//       }
    
    private func calculateTextColor() -> Color {
        if !isInRange {
            // Gray out the day if it's not in range
            return Color.gray
        } else if isSelected {
            // Selected day color
            return isToday ? .white : theme.main.accentColor
        } else if isToday {
            // Today's color if not selected
            return theme.main.accentColor
        } else {
            // Normal day color
            return theme.main.daysNumbers
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
