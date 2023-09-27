//
//  RiderDataForWatch.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/23.
//

import Foundation
import simd
import Spatial

struct UMBMeasuredData{
    let distance: Measurement<UnitLength>
    let direction: SIMD3<Float>
    let timeStamp: TimeInterval
    var euler3d: String {
        get{
            let angles = Rotation3D(angle:Angle2D.zero, axis:  RotationAxis3D(direction)).eulerAngles(order: .xyz).angles
            return String(format: "%03d", round(Measurement(value: angles.x, unit: UnitAngle.radians).converted(to: UnitAngle.degrees).value)).description + "," +
            String(format: "%03d", round(Measurement(value: angles.y, unit: UnitAngle.radians).converted(to: UnitAngle.degrees).value)).description + "," +
            String(format: "%03d", round(Measurement(value: angles.z, unit: UnitAngle.radians).converted(to: UnitAngle.degrees).value)).description
        }
    }
}
