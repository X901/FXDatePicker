
![fxPickerImage](https://github.com/X901/FXDatePicker/assets/16876982/f345da1d-cfdd-40db-9e4e-bb9c135df35d)

<p><h1 align="left">FXDatePicker</h1></p>

<p><h4>A SwiftUI library for a customizable DatePicker.</h4></p>

# Features
* Supports both Hijri and Gregorian calendars.
* Allows adding images below days using Image or SF Symbols.
* Supports Arabic and English languages.
* Compatible with Dark and Light Modes.
* Offers full customization.

# FXDatePicker vs. iOS DatePicker

* **Customization**: FXDatePicker allows for extensive customization, including the ability to add icons below dates. In contrast, the iOS DatePicker offers basic functionality with limited customization options.
* **User Interface**: FXDatePicker features a modern, adaptable interface for a tailored user experience, while the iOS DatePicker maintains a standard, unchangeable appearance.
* **Flexibility**: FXDatePicker is ideal for creating distinctive, engaging date-picking experiences. The iOS DatePicker is more suited for applications that require basic date selection.

# Usage
1. Add a binding `Date` variable to save the selection.
2. Create a `specialDates` array to add images below dates.
3. Initialize FXDatePicker and present it as desired.

```swift
FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
```

## Using `specialDates` to Add Custom Markers

The `specialDates` array allows you to add custom markers to specific dates in your calendar. You can use either custom images or SF Symbols to highlight these dates. Each special date is defined with its type (`SpecialDateType`), which can be an `ImageType` for images or an `SFSymbolsType` for SF Symbols. Format the dates in the "Day/Month/Year" format.

### Adding SF Symbols to Dates

To mark a date with an SF Symbol, create a `SpecialDate` instance with `dateType` set to `.sfSymbols`. Provide the date, the symbol's name, and its color:

```swift
let specialDates: [SpecialDate] = [
    SpecialDate(dateType: .sfSymbols(SFSymbolsType(dateString: "2/1/2024", 
                                                   imageName: "airplane.departure", 
                                                   color: .blue)))
]
```

In the above example, an airplane departure symbol in blue color will appear on 2nd January 2024.

### Adding Images to Dates
To use a custom image for marking a specific date, set dateType to .image and provide the date and image name:


```swift
        SpecialDate(dateType: .image(ImageType(dateString: "13/1/2024", imageName: "home"))
```

# Customize | Available modifiers:

### calenderType 

Change the DatePicker type using calendarType. For example, to use the Hijri calendar:

```swift
FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
.calenderType(.hijri)
```

The default is `.gregorian.`

### datePickerTheme

Customize the theme of the DatePicker using datePickerTheme. For example:

```swift
FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
.datePickerTheme(main:
 .init(
accentColor: Color(uiColor: UIColor(red: 0.23, green: 0.80, blue: 0.81, alpha: 1.00)),
monthTitle: .white,
daysName: Color(uiColor: UIColor(red: 0.45, green: 0.48, blue: 0.48, alpha: 1.00)),
daysNumbers: Color(uiColor: UIColor(red: 0.83, green: 0.84, blue: 0.84, alpha: 1.00)),
previousDaysNumber: Color(uiColor: UIColor(red: 0.44, green: 0.47, blue: 0.47, alpha: 1.00)),
backgroundColor: Color(uiColor: UIColor(red: 0.22, green: 0.25, blue: 0.25, alpha: 1.00)))
 )
```
The default theme has a white background with a blue accent color.

## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/X901/FXDatePicker.git")
]
```


## Requirements

* iOS 15+
* Xcode 13+ 

