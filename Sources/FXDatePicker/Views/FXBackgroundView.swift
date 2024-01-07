////
//FXBackgroundView.swift
//
//
//Created by Basel Baragabah on 04/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

internal struct FXBackgroundView: View {
    let background: BackgroundStyle

    var body: some View {
        ZStack {
            switch background {
            case .color(let color):
                color
            case .linearGradient(let gradient, let startPoint, let endPoint):
                LinearGradient(gradient: gradient, startPoint: startPoint, endPoint: endPoint)
            case .radialGradient(let gradient, let center, let startRadius, let endRadius):
                RadialGradient(gradient: gradient, center: center, startRadius: startRadius, endRadius: endRadius)
            case .angularGradient(let gradient, let center):
                AngularGradient(gradient: gradient, center: center)
            }
        }
    }
}

