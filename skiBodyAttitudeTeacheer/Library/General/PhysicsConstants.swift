//
// Created by koyanagi on 2021/11/07.
//

import Foundation

class PhysicsConstants {
    static let G = 9.80665 // m/s^2

    static func timeIntervalToSecond(_ timeInterval: TimeInterval)
                    -> Double {
        timeInterval / 60
    }
    // m/s
    static func accelerationToVelocity(accelerationByG: Double, elapsedTime: TimeInterval) -> Double{
        accelerationByG * G * timeIntervalToSecond(elapsedTime)
    }
}
