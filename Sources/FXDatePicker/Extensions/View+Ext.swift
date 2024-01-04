////
//SwiftUIView.swift
//
//
//Created by Basel Baragabah on 04/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

extension View {
    @ViewBuilder func background(_ background: BackgroundStyle) -> some View {
        switch background {
        case .color(let color):
             self.overlay(Color.clear)
                .background(color)
        case .linearGradient(let gradient, let startPoint, let endPoint):
             self.overlay(Color.clear)
                .background(LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint))
        case .radialGradient(let gradient, let center, let startRadius, let endRadius):
             self.overlay(Color.clear)
                .background(RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius))
        case .angularGradient(let gradient, let center):
             self.overlay(Color.clear)
                .background(AngularGradient(gradient: gradient, center: center))
        }
    }
}
