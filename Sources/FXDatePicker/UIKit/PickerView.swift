////
//PickerView.swift
//
//
//Created by Basel Baragabah on 03/01/2024.
//Copyright © 2024 Basel Baragabah. All rights reserved.
//

import SwiftUI


internal struct FXPickerView: UIViewRepresentable {
    @Binding var data: [[String]]
    @Binding var selections: [Int]
    var textColor: UIColor = .black
    
    internal func makeCoordinator() -> FXPickerView.Coordinator {
        Coordinator(self)
    }
    
    internal func makeUIView(context: UIViewRepresentableContext<FXPickerView>) -> UIPickerView {
        let picker = UIPickerView(frame: .zero)
        
        picker.dataSource = context.coordinator
        picker.delegate = context.coordinator
        
        return picker
    }
    
    internal func updateUIView(_ view: UIPickerView, context: UIViewRepresentableContext<FXPickerView>) {
        for i in 0...(self.selections.count - 1) {
            view.selectRow(self.selections[i], inComponent: i, animated: true)
        }
        
        DispatchQueue.main.async {
            view.reloadAllComponents() // Reload components at the end
            
            // If only one month is available, select it automatically
            if self.data.count > 1 && self.data[1].count == 1 {
                self.selections[1] = 0
                view.selectRow(0, inComponent: 1, animated: false)
            }
        }
        
        context.coordinator.parent = self
    }
    
    
    internal class Coordinator: NSObject, UIPickerViewDataSource, UIPickerViewDelegate {
        var parent: FXPickerView
        
        internal init(_ pickerView: FXPickerView) {
            self.parent = pickerView
        }
        
        internal func numberOfComponents(in FXPickerView: UIPickerView) -> Int {
            return self.parent.data.count
        }
        
        internal func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return self.parent.data[component].count
        }
        
        internal func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
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
        
        internal func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            self.parent.selections[component] = row
        }
    }
}
