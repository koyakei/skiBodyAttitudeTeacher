//
//  TowAngleDiffrencial.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
struct TwoAngleDiffrencial {
    // pi to - pi  180 to - 180
    static func handle(angle: Double, secondAngle: Double) -> Double{
        atan2(sin( angle - secondAngle ),cos(angle - secondAngle))
    }
}
