//
// Created by koyanagi on 2021/11/11.
//　指定した方向への加速度と現在の姿勢からの相対角度を取得

import Foundation
import CoreMotion
import simd
struct AccelerationForTargetAngle {
    static func getRelativeAttitude(userAttitude: Attitude, targetAttitude: Attitude) -> Attitude{
        Attitude.init(roll:
                      TwoAngleDifferential.handle(angle: targetAttitude.roll, secondAngle: userAttitude.roll)

                , yaw:
                      TwoAngleDifferential.handle(angle: targetAttitude.yaw, secondAngle: userAttitude.yaw)
                ,
                      pitch:
                      TwoAngleDifferential.handle(angle: targetAttitude.pitch, secondAngle: userAttitude.pitch))
    }


    static func handle(userAcceleration: CMAcceleration, userAttitude: simd_quatd, targetAttitude: simd_quatd)
                    -> simd_double3 {
        return simd_axis( targetAttitude - userAttitude ) *
                simd_double3(userAttitude.vector.x, userAttitude.vector.y,
                             userAttitude.vector.z)
    }
}


struct TargetDirectionAccelerationAndRelativeAttitude {
    let targetDirectionAcceleration: simd_double3
    let relativeAttitude: simd_quatd
}
