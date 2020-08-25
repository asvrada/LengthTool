//
//  ContentView.swift
//  LengthTool
//
//  Created by Zijie Wu on 8/24/20.
//  Copyright © 2020 Zijie Wu. All rights reserved.
//

import SwiftUI



struct ContentView: View {
    private let listUnitImperial: [BaseUnit] = [Inch(), Foot(), Yard(), Mile()]
    private let listUnitMetric: [BaseUnit] = [Centimeter(), Meter(), Kilometer()]

    private var optionsLengthUnitImperial: [String] {
        listUnitImperial.map { $0.name }
    }
    private var optionsLengthUnitMetric: [String] {
        listUnitMetric.map { $0.name }
    }

    @State private var selectOptionsLengthUnitImperial = 0
    @State private var selectOptionsLengthUnitMetric = 0

    private var unitImperial: BaseUnit {
        listUnitImperial[selectOptionsLengthUnitImperial]
    }

    private var unitMetric: BaseUnit {
        listUnitMetric[selectOptionsLengthUnitMetric]
    }

    // 0: Imperial one
    // 1: Metric one
    @State private var textFieldEditing = 0
    @State private var textFieldContent: String = ""

    @State private var amountInMeter: Double? = nil

    // Behavior:
    // If user is editing this number, then make sure the content doesn't change unless its user input
    // If not, then change to reflect the real number
    @State private var amountImperial: Double? = nil
    private var inputAmountImperial: Binding<String> {
        Binding (
            get: {
                if self.textFieldEditing == 0 {
                    return self.textFieldContent
                }

                if let number = self.amountInMeter {
                    return String(number / self.unitImperial.unitAmountInMeter)
                } else {
                    return ""
                }
            },
            set: {
                self.textFieldEditing = 0
                self.textFieldContent = $0

                if let number = Double($0) {
                    self.amountInMeter = number * self.unitImperial.unitAmountInMeter
                }
            }
        )
    }

    @State private var amountMetric: Double? = nil
    private var inputAmountMetric: Binding<String> {
        Binding (
            get: {
                if self.textFieldEditing == 1 {
                    return self.textFieldContent
                }

                if let number = self.amountInMeter {
                    return String(number / self.unitMetric.unitAmountInMeter)
                } else {
                    return ""
                }
            },
            set: {
                self.textFieldEditing = 1
                self.textFieldContent = $0

                if let number = Double($0) {
                    self.amountInMeter = number * self.unitMetric.unitAmountInMeter
                }
            }
        )
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Debug")) {
                    Text("\(amountInMeter ?? 0) amountInMeter")

//                    Text("\(amountImperial ?? 0) amountImperial")
//                    Text("\(amountMetric ?? 0) amountMetric")
                }

                Section(header: Text("Freedom Unit")) {
                    TextField("Imperial Unit Amount", text: inputAmountImperial)
                        .keyboardType(.decimalPad)

                    Picker("Pick Imperial Unit", selection: $selectOptionsLengthUnitImperial) {
                        ForEach(0 ..< optionsLengthUnitImperial.count) {
                            Text("\(self.optionsLengthUnitImperial[$0])").tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Ratio")) {
                    Text("Placeholder for Ratio")
                }

                Section(header: Text("Metric")) {
                    TextField("Metric Unit Amount", text: inputAmountMetric)
                        .keyboardType(.decimalPad)

                    Picker("Pick Metric Unit", selection: $selectOptionsLengthUnitMetric) {
                        ForEach(0 ..< optionsLengthUnitMetric.count) {
                            Text("\(self.optionsLengthUnitMetric[$0])").tag($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
            }
            .navigationBarTitle("Length Convert Tool")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
