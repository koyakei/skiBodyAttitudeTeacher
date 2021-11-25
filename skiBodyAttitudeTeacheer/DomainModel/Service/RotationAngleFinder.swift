//
// Created by koyanagi on 2021/11/25.
//

import Foundation
import CoreMotion
struct RotationAngleFinder {
    var beforeAngle : Double = 0
    var beforeTimeStamp: TimeInterval = Date.now.timeIntervalSince1970
// radians/second
    mutating func handle(radianAngle: Double, timeStamp: TimeInterval) -> CMRotationRate{
        let diff = TwoAngleDifferential.handle(angle: radianAngle, secondAngle: beforeAngle)
        let sec = timeStamp - beforeTimeStamp
        beforeAngle = radianAngle
        beforeTimeStamp = timeStamp
        return CMRotationRate.init(x: 0, y: 0, z: diff / sec)
    }
}
