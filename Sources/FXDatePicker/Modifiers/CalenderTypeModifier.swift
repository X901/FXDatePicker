////
//CalenderType.swift
//DatePickerExample
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

public enum CalenderType {
    case gregorian
    case hijri
}

public struct CalenderTypeModifier: ViewModifier {
    var calenderType: CalenderType
    
    public func body(content: Content) -> some View {
        content
            .environment(\.calenderType, calenderType)
    }
}

public struct CalenderTypeKey: EnvironmentKey {
    public static let defaultValue: CalenderType = .gregorian
}

public extension EnvironmentValues {
    var calenderType: CalenderType {
        get { self[CalenderTypeKey.self] }
        set { self[CalenderTypeKey.self] = newValue }
    }
}

public extension View {
    func calenderType(_ type: CalenderType) -> some View {
        self.modifier(CalenderTypeModifier(calenderType: type))
    }
}
