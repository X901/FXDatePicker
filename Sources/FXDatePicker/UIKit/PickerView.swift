////
//PickerView.swift
//
//
//Created by Basel Baragabah on 03/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI


struct PickerView: UIViewRepresentable {
    var data: [[String]]
    @Binding var selections: [Int]
    var textColor: UIColor = .black

    func makeCoordinator() -> PickerView.Coordinator {
        Coordinator(self)
    }

    func makeUIView(context: UIViewRepresentableContext<PickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator

        return picker
    }

    func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<PickerView>) {
        for i in 0...(self.selections.count - 1) {
            view.selectRow(self.selections[i], inComponent: i, animated: false)
        }
        context.coordinator.parent = self
    }
    
    class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: PickerView
        
        init(_ pickerView: PickerView) {
            self.parent = pickerView
        }
        
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }
        
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }
        
        func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
            var label: UILabel
            if let reuseLabel = view as? UILabel {
                label = reuseLabel
            } else {
                label = UILabel()
            }
            
            label.text = self.parent.data[component][row]
            label.textColor = parent.textColor
            label.textAlignment = .center
            label.font = UIFont.systemFont(ofSize: 24)

            return label
        }
        
        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
    }
}
