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
              UserDefaults.standard.set(["en"], forKey: "AppleLanguages")
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

    private var cloaseRange: ClosedRange<Date> {
        let calendar = Calendar.current
        // Set 'today' to the start of the current day
         let startOfToday = calendar.startOfDay(for: Date())
        
            guard let endOfRange = calendar.date(bySetting: .day, value: 18, of: startOfToday) else {
            fatalError("Could not create start or end date for range")
        }

        return startOfToday...endOfRange
    }

    
    var body: some View {
        
        
        VStack {
            
//            Picker("", selection: $selectedCalender) {
//                Text("Gregorian").tag(0)
//                Text("Hijri").tag(1)
//            }
//            .pickerStyle(.segmented)
//            .onChange(of: selectedCalender) { value in
//                if value == 0 {
//                    calenderType = .gregorian
//                } else {
//                    calenderType = .hijri(.islamicUmmAlQura)
//                }
//            }

            switch calenderType {
            case .gregorian:
//                FXDatePickerView(selectedDate: $selectedGregorianDate, specialDates: specialDates)
                
                FXDatePickerView(selectedDate: $selectedGregorianDate, specialDates: specialDates, in: cloaseRange)
                  // .hideMarkers()
                  // .hideDatePicker()
//                   .disableSwipe()
                    .calenderType(calenderType)
                    .datePickerTheme(main:
                        .init(
                        accentColor: Color(UIColor(red: 0.82, green: 0.26, blue: 0.42, alpha: 1.00)),
                        monthTitle: Color(UIColor(red: 0.86, green: 0.87, blue: 0.88, alpha: 1.00)),
                        daysName: Color(UIColor(red: 0.80, green: 0.80, blue: 0.83, alpha: 1.00)),
                        daysNumbers: Color(UIColor(red: 0.83, green: 0.83, blue: 0.87, alpha: 1.00)),
                        previousDaysNumber: Color(UIColor(red: 0.66, green: 0.66, blue: 0.69, alpha: 1.00)),
                        backgroundStyle:
                                .radialGradient(
                               Gradient(colors:
                                  [Color(UIColor(red: 0.19, green: 0.19, blue: 0.22, alpha: 1.00)),
                                   Color(UIColor(red: 0.11, green: 0.11, blue: 0.14, alpha: 1.00))
                                  ]
                                       ),
                                  center: .center,
                                  startRadius: 1,
                                 endRadius: 300)
                           )
                       )
                                     
            case .hijri:
                
                FXDatePickerView(selectedDate: $selectedGregorianDate, specialDates: specialDates)
                   .hideMarkers()
                  // .disableSwipe()
                    .calenderType(calenderType)
                    .datePickerTheme(main:
                        .init(
                        accentColor: Color(UIColor(red: 0.49, green: 0.76, blue: 0.96, alpha: 1.00)),
                        monthTitle: .white,
                        daysName: Color(UIColor(red: 0.96, green: 0.98, blue: 0.99, alpha: 1.00)),
                        daysNumbers: Color(UIColor(red: 0.96, green: 0.98, blue: 0.99, alpha: 1.00)),
                        previousDaysNumber: Color(UIColor(red: 0.19, green: 0.47, blue: 0.76, alpha: 1.00)),
                        backgroundStyle: .color(Color(UIColor(red: 0.01, green: 0.33, blue: 0.64, alpha: 1.00))))
                       )
            }
            
           
        }

        
    }
}

#Preview {
    ContentView()
}
