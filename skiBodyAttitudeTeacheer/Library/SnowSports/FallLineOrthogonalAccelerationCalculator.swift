//
// Created by koyanagi on 2021/11/25.
//

import Foundation
import CoreMotion
struct FallLineOrthogonalAccelerationCalculator{
    // 絶対　north true absolute fallLine
    // absoluteUserAttitude true north
    // userAcceleration も absolute
    static func handle(absoluteFallLineAttitude: Attitude,
                       turnYawingSide : TurnYawingSide,
                       userAcceleration: CMAcceleration,
                       userAttitude: Attitude
    ) -> TargetDirectionAccelerationAndRelativeAttitude{
        AccelerationForTargetAngle.handle(
                userAcceleration: userAcceleration,
                userAttitude: userAttitude,
                targetAttitude: FallLineOutSideOrthogonalDirectionFinder.handle(fallLineAttitude: absoluteFallLineAttitude, turnYawingSide: turnYawingSide))
    }
}
