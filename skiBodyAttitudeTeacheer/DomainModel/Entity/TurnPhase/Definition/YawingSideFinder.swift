//
// Created by koyanagi on 2021/11/19.
//

import Foundation
import CoreMotion

struct YawingSideFinder {
    static func handle(currentRotationRate: CMRotationRate)
                    -> TurnYawingSide{
        switch currentRotationRate.z {
        case -.infinity..<Double.zero:
            return TurnYawingSide.RightYawing
        case 0.0000001...Double.infinity:
            return TurnYawingSide.LeftYawing
        default:
            return TurnYawingSide.Straight
        }
    }
}
