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
    
    public init(dateType: SpecialDateType) {
        self.dateType = dateType
    }
}

public enum SpecialDateType {
    case image(ImageType)
    case sfSymbols(SFSymbolsType)
}

public struct ImageType {
    var dateString: String
    var imageName: String
    
   public init(dateString: String, imageName: String) {
        self.dateString = dateString
        self.imageName = imageName
    }
}

public struct SFSymbolsType {
    var dateString: String
    var imageName: String
    var color: Color
    
   public init(dateString: String, imageName: String, color: Color) {
        self.dateString = dateString
        self.imageName = imageName
        self.color = color
    }
}
