//
// Created by koyanagi on 2021/11/19.
//

import Foundation

struct YawingSideFinder {
    static func handle(absoluteFallLineAttitude: Attitude,
                currentMovingPhase: MovingPhaseProtocol)
                    -> TurnYawingSide{
        switch currentMovingPhase.rotationRate.z {
        case -.infinity..<Double.zero:
            return TurnYawingSide.RightYawing
        case 0.0000001...Double.infinity:
            return TurnYawingSide.LeftYawing
        default:
            return TurnYawingSide.Straight
        }
    }
}
