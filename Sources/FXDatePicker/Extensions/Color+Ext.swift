////
//SwiftUIView.swift
//
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

public extension Color {
    init(color: UIColor) {
        if #available(iOS 15.0, *) {
            self.init(uiColor: color)
        } else {
            let ciColor = CIColor(color: color)
            self.init(red: Double(ciColor.red), green: Double(ciColor.green), blue: Double(ciColor.blue), opacity: Double(ciColor.alpha))
        }
    }
}
