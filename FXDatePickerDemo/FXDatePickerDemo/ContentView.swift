////
//ContentView.swift
//FXDatePickerDemo
//
//Created by Basel Baragabah on 30/12/2023.
//Copyright © 2023 Basel Baragabah. All rights reserved.
//

import SwiftUI
import FXDatePicker

struct ContentView: View {
    
//    init() {
//        // Change the app language to Arabic
//              UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
//           }
        
    @State private var selectedDate = Date()

    let specialDates: [SpecialDate] = [
        
        SpecialDate(dateString: "19/6/1445", dateType: .sfSymbols(SFSymbolsType( imageName: "figure.walk", color: .red))),
        
        SpecialDate(dateString: "2/1/2024", dateType: .sfSymbols(SFSymbolsType( imageName: "airplane.departure", color: .blue))),

        SpecialDate(dateString: "11/1/2024", dateType: .sfSymbols(SFSymbolsType(imageName: "phone.fill", color: .orange))),

        SpecialDate(dateString: "4/1/2024", dateType: .sfSymbols(SFSymbolsType(imageName: "balloon.fill", color: .green))),

        SpecialDate(dateString: "19/1/2024", dateType: .sfSymbols(SFSymbolsType(imageName: "figure.walk", color: .purple))),

        SpecialDate(dateString: "31/1/2024", dateType: .sfSymbols(SFSymbolsType(imageName: "figure.walk", color: .purple))),
                
        SpecialDate(dateString: "13/1/2024",dateType: .image(ImageType(imageName: "home")))
        
    ]
    
    @State private var selectedCalender = 0
    @State private var calenderType: CalenderType = .gregorian

    var body: some View {
        
        VStack {
            
            Picker("", selection: $selectedCalender) {
                Text("Gregorian").tag(0)
                Text("Hijri").tag(1)
            }
            .pickerStyle(.segmented)
            .onChange(of: selectedCalender) { value in
                if value == 0 {
                    calenderType = .gregorian
                } else {
                    calenderType = .hijri
                }
            }

            
            FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
              // .hideMarkers()
                .calenderType(calenderType)
                .datePickerTheme(main:
                    .init(
                    accentColor: Color(uiColor: UIColor(red: 0.23, green: 0.80, blue: 0.81, alpha: 1.00)),
                    monthTitle: .white,
                    daysName: Color(uiColor: UIColor(red: 0.45, green: 0.48, blue: 0.48, alpha: 1.00)),
                    daysNumbers: Color(uiColor: UIColor(red: 0.83, green: 0.84, blue: 0.84, alpha: 1.00)),
                    previousDaysNumber: Color(uiColor: UIColor(red: 0.44, green: 0.47, blue: 0.47, alpha: 1.00)),
                   backgroundColor: Color(uiColor: UIColor(red: 0.22, green: 0.25, blue: 0.25, alpha: 1.00)))
                   )
        }

        
    }
}

#Preview {
    ContentView()
}
