////
//ThemeColorModifier.swift
//FXDatePicker
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

@available(iOS 14.0, *)
 public struct DatePickerThemeKey: EnvironmentKey {
    public static var defaultValue: DatePickerTheme = DatePickerTheme()

}

public extension EnvironmentValues {
    var datePickerTheme: DatePickerTheme {
        get { self[DatePickerThemeKey.self] }
        set { self[DatePickerThemeKey.self] = newValue }
    }
}

public extension View {
    func datePickerTheme(_ theme: DatePickerTheme) -> some View {
        self.environment(\.datePickerTheme, theme)
    }
    
    func datePickerTheme(
        main: DatePickerTheme.Main = .init()
    ) -> some View {
        self.environment(\.datePickerTheme, DatePickerTheme(main: main))
    }
}

public struct DatePickerTheme {
    public let main: Main
    
    public init(main: DatePickerTheme.Main = .init()) {
        self.main = main
    }
}


public extension DatePickerTheme {
    struct Main {
        public let accentColor: Color
        public let monthTitle: Color
        public let daysName: Color
        public let daysNumbers: Color
        public let previousDaysNumber: Color
        public let backgroundStyle: BackgroundStyle
        
        public init(accentColor: Color = .blue,
                    monthTitle: Color = Color(UIColor.label),
                    daysName: Color = .gray,
                    daysNumbers: Color = Color(UIColor.label),
                    previousDaysNumber: Color = .gray,
                    backgroundStyle: BackgroundStyle = .color(Color(UIColor.systemBackground))) {
            
            self.accentColor = accentColor
            self.monthTitle = monthTitle
            self.daysName = daysName
            self.daysNumbers = daysNumbers
            self.previousDaysNumber = previousDaysNumber
            self.backgroundStyle = backgroundStyle
            
        }
    }
}

public enum BackgroundStyle {
    case color(Color)
    case linearGradient(Gradient, startPoint: UnitPoint, endPoint: UnitPoint)
    case radialGradient(Gradient, center: UnitPoint, startRadius: CGFloat, endRadius: CGFloat)
    case angularGradient(Gradient, center: UnitPoint)
}
