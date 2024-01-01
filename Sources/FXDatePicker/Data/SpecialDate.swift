////
//SpecialDate.swift
//DatePickerExample
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import Foundation
import SwiftUI

public struct SpecialDate {
    var dateType: SpecialDateType
}

public enum SpecialDateType {
    case image(ImageType)
    case sfSymbols(SFSymbolsType)
}

public struct ImageType {
    var dateString: String
    var imageName: String
}

public struct SFSymbolsType {
    var dateString: String
    var imageName: String
    var color: Color
}
