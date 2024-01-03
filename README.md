
![FXDatePickerImage](https://github.com/X901/FXDatePicker/assets/16876982/b63eeab8-fc69-4f8f-b94f-459539f4b1cf)

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

To mark a date with an SF Symbol, create a `SpecialDate` instance with `dateString` and `dateType` set to `.sfSymbols`. Provide the date, the symbol's name, and its color:

```swift
SpecialDate(dateString: "2/1/2024", 
dateType: .sfSymbols(SFSymbolsType(imageName: "airplane.departure",
color: .blue)))
]
```

In the above example, an airplane departure symbol in blue color will appear on 2nd January 2024.

### Adding Images to Dates
For a custom image, set dateType to .image and provide the date along with the name of the image:

```swift
     SpecialDate(dateString: "13/1/2024",
     dateType: .image(ImageType(imageName: "home")))
```

# Customize | Available modifiers:

### calenderType 

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

### hideMarkers

The `hideMarkers()` modifier allows you to use the `FXDatePickerView` as a regular calendar without displaying any special date markers. This is particularly useful if you want a cleaner look or if the special date indicators are not needed for certain use cases.

Example
To apply this modifier, simply chain `.hideMarkers()` to your `FXDatePickerView` instance. Here’s how you can do it:

```swift
FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
    .hideMarkers()
```

Here's how it looks with the hideMarkers() modifier applied:


<img src="https://github.com/X901/FXDatePicker/assets/16876982/49d39bf9-9379-487b-8b2e-a0447d4bb48a" height="350">


With this modifier, the FXDatePickerView will render without showing any markers associated with the specialDates. This keeps the calendar view simple and focused on basic date picking functionality.

--

### disableSwipe

The `.disableSwipe()` modifier is used with the `FXDatePickerView` to disable the swipe gesture functionality. This can be particularly useful in scenarios where you want to prevent users from changing the date by swiping, ensuring that navigation through dates is controlled through other means (like buttons or external controls).

Example
To apply this modifier, simply chain `.disableSwipe()` to your `FXDatePickerView` instance. Here’s how you can do it:

```swift
FXDatePickerView(selectedDate: $selectedDate, specialDates: specialDates)
    .disableSwipe()
```
In this example, the `FXDatePickerView` will no longer respond to swipe gestures for date navigation, and users will need to use buttons provided in the UI to change the selected date.


## Installation

### [Swift Package Manager](https://swift.org/package-manager/)

```swift
dependencies: [
    .package(url: "https://github.com/X901/FXDatePicker.git")
]
```


## Requirements

* iOS 14+
* Xcode 13+ 

