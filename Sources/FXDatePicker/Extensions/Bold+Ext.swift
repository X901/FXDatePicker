////
//Bold+Ext.swift
//
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

public extension View {
    @ViewBuilder func toBold(_ condition: Bool = true) -> some View {
        if condition {
            if #available(iOS 16.0, *) {
                self.bold()
            } else {
                self.font(Font.body.bold())
            }
        } else {
            self
        }
    }
}

