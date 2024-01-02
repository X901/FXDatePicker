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
    var dateString: String
    var dateType: SpecialDateType
    
    public init(dateString: String, dateType: SpecialDateType) {
        self.dateString = dateString
        self.dateType = dateType
    }
}

public enum SpecialDateType {
    case image(ImageType)
    case sfSymbols(SFSymbolsType)
}

public struct ImageType {
    var imageName: String
    
   public init(imageName: String) {
        self.imageName = imageName
    }
}

public struct SFSymbolsType {
    var imageName: String
    var color: Color
    
   public init(imageName: String, color: Color) {
        self.imageName = imageName
        self.color = color
    }
}
