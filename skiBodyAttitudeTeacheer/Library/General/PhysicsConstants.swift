//
// Created by koyanagi on 2021/11/07.
//

import Foundation
import SwiftUI

class PhysicsConstants {
    static let G = 9.80665 // m/s^2
    static let degree : Double = .pi / 180

    // m/s
    static func accelerationToVelocity(accelerationByG: Double, elapsedTime: TimeInterval, initialVelocity : Double = 0) -> Double{
        initialVelocity + accelerationByG * G * elapsedTime
    }
    static func 距離(accelerationByG: Double, elapsedTime: TimeInterval, initialVelocity : Double = 0) -> Double{
        initialVelocity * elapsedTime + ((accelerationByG * G) * elapsedTime * elapsedTime/2)
    }
}
