//
//  MotionRecord.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/30.
//

import Foundation
import CoreMotion
import CoreLocation
struct TrunPhase{
    let attitude: Attitude
    let userAccelaration: CMAcceleration
    let timeStampSInce1970: TimeInterval
    struct Attitude{
        let roll : Double
        let yaw: Double
        let pitch: Double
    }
}
