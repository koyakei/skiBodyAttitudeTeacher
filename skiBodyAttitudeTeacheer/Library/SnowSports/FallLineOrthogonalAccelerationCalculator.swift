//
// Created by koyanagi on 2021/11/25.
//

import Foundation
import CoreMotion
import simd

struct FallLineOrthogonalAccelerationCalculator{
    // 絶対　north true absolute fallLine
    // absoluteUserAttitude true north
    // userAcceleration も absolute
    static func handle(absoluteFallLineAttitude: simd_quatd,
                       turnYawingSide : TurnYawingSide,
                       userAcceleration: CMAcceleration,
                       userAttitude: simd_quatd
    ) -> TargetDirectionAccelerationAndRelativeAttitude{
        let targetQAttitude = FallLineOutSideOrthogonalDirectionFinder.init(fallLineAttitude: absoluteFallLineAttitude, turnYawingSide: turnYawingSide).handle()
        return TargetDirectionAccelerationAndRelativeAttitude.init(targetDirectionAcceleration: AccelerationForTargetAngle.getMatrix(userAcceleration: userAcceleration,                                                                                              userAttitude: userAttitude, targetAttitude: targetQAttitude), relativeAttitude: targetQAttitude)
    }
}
