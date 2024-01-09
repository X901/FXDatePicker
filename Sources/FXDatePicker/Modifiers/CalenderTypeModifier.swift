////
//CalenderType.swift
//FXDatePicker
//
//Created by Basel Baragabah on 01/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI

public enum HijriType {
    case islamicUmmAlQura
    case islamic
    case islamicCivil
    case islamicTabular
}

public enum CalenderType {
    case gregorian
    case hijri(HijriType)
}
