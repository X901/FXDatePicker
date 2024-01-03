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
    
    init() {
        // Change the app language to Arabic
              UserDefaults.standard.set(["ar"], forKey: "AppleLanguages")
           }
        
    @State private var selectedGregorianDate = Date()
    @State private var selectedHijriDate = Date()

    let specialDates: [SpecialDate] = [
        
        SpecialDate(dateString: "19/6/1445", dateType: .sfSymbols(SFSymbolsType( imageName: "figure.walk", color: .red))),
        
        SpecialDate(dateString: "2/1/2024", dateType: .sfSymbols(SFSymbolsType( imageName: "airplane.departure", color: .red))),

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

            switch calenderType {
            case .gregorian:
                FXDatePickerView(selectedDate: $selectedGregorianDate, specialDates: specialDates)
                  // .hideMarkers()
                  // .disableSwipe()
                    .calenderType(calenderType)
                    .datePickerTheme(main:
                        .init(
                        accentColor: Color(UIColor(red: 0.49, green: 0.76, blue: 0.96, alpha: 1.00)),
                        monthTitle: .white,
                        daysName: Color(UIColor(red: 0.96, green: 0.98, blue: 0.99, alpha: 1.00)),
                        daysNumbers: Color(UIColor(red: 0.96, green: 0.98, blue: 0.99, alpha: 1.00)),
                        previousDaysNumber: Color(UIColor(red: 0.19, green: 0.47, blue: 0.76, alpha: 1.00)),
                       backgroundColor: Color(UIColor(red: 0.01, green: 0.33, blue: 0.64, alpha: 1.00)))
                       )
            case .hijri:
                
                FXDatePickerView(selectedDate: $selectedGregorianDate, specialDates: specialDates)
                   .hideMarkers()
                   .disableSwipe()
                    .calenderType(calenderType)
            }
            
           
        }

        
    }
}

#Preview {
    ContentView()
}
