//
//  ContentView.swift
//  LengthTool
//
//  Created by Zijie Wu on 8/24/20.
//  Copyright © 2020 Zijie Wu. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    private let DEBUG = false

    private let listUnitImperial: [BaseUnit] = [Inch(), Foot(), Yard(), Mile()]
    private let listUnitMetric: [BaseUnit] = [Centimeter(), Meter(), Kilometer()]

    private var optionsLengthUnitImperial: [String] {
        listUnitImperial.map {
            $0.name
        }
    }
    private var optionsLengthUnitMetric: [String] {
        listUnitMetric.map {
            $0.name
        }
    }

    @State private var selectOptionsLengthUnitImperial = 0
    @State private var selectOptionsLengthUnitMetric = 0

    private var bindingSelectionImperial: Binding<Int> {
        Binding(
            get: {
                return self.selectOptionsLengthUnitImperial
            }, set: {
                self.selectOptionsLengthUnitImperial = $0

                // also update amountInMeter
                if self.textFieldEditing == 0 {
                    if let number = self.amountImperial {
                        self.amountInMeter = number * self.unitImperial.unitAmountInMeter
                    }
                }
            }
        )
    }

    private var bindingSelectionMetric: Binding<Int> {
        Binding(
            get: {
                return self.selectOptionsLengthUnitMetric
            }, set: {
                self.selectOptionsLengthUnitMetric = $0

                // also update amountInMeter
                if self.textFieldEditing == 1 {
                    if let number = self.amountMetric {
                        self.amountInMeter = number * self.unitMetric.unitAmountInMeter
                    }
                }
            }
        )
    }

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
    private var bindingInputAmountImperial: Binding<String> {
        Binding(
            get: {
                if self.textFieldEditing == 0 {
                    return self.textFieldContent
                }

                if let number = self.amountInMeter {
                    return String(format: "%.2f", number / self.unitImperial.unitAmountInMeter)
                } else {
                    return ""
                }
            },
            set: {
                self.textFieldEditing = 0
                self.textFieldContent = $0

                if $0.count == 0 {
                    self.amountImperial = nil
                    self.amountInMeter = nil
                    return
                }

                if let number = Double($0) {
                    self.amountImperial = number
                    self.amountInMeter = number * self.unitImperial.unitAmountInMeter
                }
            }
        )
    }

    @State private var amountMetric: Double? = nil
    private var bindingInputAmountMetric: Binding<String> {
        Binding(
            get: {
                if self.textFieldEditing == 1 {
                    return self.textFieldContent
                }

                if let number = self.amountInMeter {
                    return String(format: "%.2f", number / self.unitMetric.unitAmountInMeter)
                } else {
                    return ""
                }
            },
            set: {
                self.textFieldEditing = 1
                self.textFieldContent = $0

                if $0.count == 0 {
                    self.amountInMeter = nil
                    self.amountInMeter = nil
                    return
                }

                if let number = Double($0) {
                    self.amountMetric = number
                    self.amountInMeter = number * self.unitMetric.unitAmountInMeter
                }
            }
        )
    }

    private var ratioString: String {
        getRatioString(isFromImperialToMetric: self.textFieldEditing == 0, imperial: unitImperial, metric: unitMetric)
    }

    var body: some View {
        NavigationView {
            Form {
                if DEBUG {
                    Section(header: Text("Debug")) {
                        Text("\(amountInMeter ?? -1) amountInMeter")

                        Text("\(amountImperial ?? -1) amountImperial")
                        Text("\(amountMetric ?? -1) amountMetric")
                    }
                }

                Section(header: Text("Imperial Unit")) {
                    TextField("Imperial Unit Amount", text: bindingInputAmountImperial)
                        .keyboardType(.decimalPad)

                    Picker("Pick Imperial Unit", selection: bindingSelectionImperial) {
                        ForEach(0..<optionsLengthUnitImperial.count) {
                            Text("\(self.optionsLengthUnitImperial[$0])").tag($0)
                        }
                    }
                        .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Ratio")) {
                    Text("\(ratioString)")
                }

                Section(header: Text("Metric")) {
                    TextField("Metric Unit Amount", text: bindingInputAmountMetric)
                        .keyboardType(.decimalPad)

                    Picker("Pick Metric Unit", selection: bindingSelectionMetric) {
                        ForEach(0..<optionsLengthUnitMetric.count) {
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
