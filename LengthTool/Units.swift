//
//  Units.swift
//  LengthTool
//
//  Created by Zijie Wu on 8/24/20.
//  Copyright © 2020 Zijie Wu. All rights reserved.
//

import Foundation

// Base: Meter in Metric system
protocol BaseUnit {
    var name: String { get }

    // What would the amount be if this long is in Meter
    // meters = self / amountInMeter
    var unitAmountInMeter: Double { get }
}

func getRatioString(isFromImperialToMetric: Bool, imperial: BaseUnit, metric: BaseUnit) -> String {

    // 1 Foot is xxx Meter
    if isFromImperialToMetric {
        let amount: Double = 1.0 * imperial.unitAmountInMeter / metric.unitAmountInMeter
        return "1 \(imperial.name) is \(String(format: "%.2f", amount)) \(metric.name)"
    } else {
        let amount: Double = 1.0 * metric.unitAmountInMeter / imperial.unitAmountInMeter
        return "1 \(metric.name) is \(String(format: "%.2f", amount)) \(imperial.name)"
    }
}

// Metric System

struct Meter : BaseUnit {
    let name = "Meter"
    let unitAmountInMeter = 1.0
}

struct Centimeter: BaseUnit {
    let name = "Centimeter"
    let unitAmountInMeter: Double = 0.001
}

struct Kilometer: BaseUnit {
    let name = "Kilometer"
    let unitAmountInMeter: Double = 1000
}

// Imperial System

struct Inch: BaseUnit {
    let name = "Inch"
    let unitAmountInMeter: Double = 0.0254
}

struct Foot: BaseUnit {
    let name: String = "Foot"
    let unitAmountInMeter: Double = 0.3048
}

struct Yard: BaseUnit {
    let name: String = "Yard"
    let unitAmountInMeter: Double = 0.9144
}

struct Mile: BaseUnit {
    let name: String = "Mile"
    let unitAmountInMeter: Double = 1609.344
}

extension Double {
    static func powd(base: Double, power: Int) -> Double {
        return 1.0
    }

    func roundTo(count: Int) -> Double {
        let amount: Double = Double.powd(base: 10.0, power: count)
        return (amount * self).rounded() / amount
    }
}
