//
//  Helper.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/23.
//

import Foundation

enum Helper {
    
    /// A key that is used for transferring discovery tokens between devices.
    static let ridersDataTokenKey: String = "riders-data-token"
    static let ridersDataKey: String = "riders-data"
    
    /// A formatter that converts a distance to a string with units.
    static var localFormatter: MeasurementFormatter = {
        let formatter = MeasurementFormatter()
        formatter.unitStyle = .medium
        formatter.unitOptions = .providedUnit
        formatter.numberFormatter.alwaysShowsDecimalSeparator = true
        formatter.numberFormatter.roundingMode = .ceiling
        formatter.numberFormatter.maximumFractionDigits = 1
        formatter.numberFormatter.minimumFractionDigits = 1
        return formatter
    }()
    
    /// The unit length for the device's current locale.
    static var localUnits: UnitLength {
        Locale.current.usesMetricSystem ? .centimeters : .feet
    }
}
