//
// Created by koyanagi on 2021/11/25.
//

import Foundation
import CoreMotion
struct FallLineOrthogonalAccelerationCalculator{
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
