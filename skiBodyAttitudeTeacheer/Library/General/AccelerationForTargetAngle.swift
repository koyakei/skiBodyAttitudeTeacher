//
// Created by koyanagi on 2021/11/11.
//　指定した方向への加速度と現在の姿勢からの相対角度を取得

import Foundation
import CoreMotion

struct AccelerationForTargetAngle {
    static func handle(userAcceleration: CMAcceleration, userAttitude: Attitude, targetAttitude: Attitude)
                    -> TargetDirectionAccelerationAndRelativeAttitude {
        let relativeAttitude: Attitude = Attitude.init(roll: targetAttitude.roll - userAttitude.roll, yaw: targetAttitude.yaw - userAttitude.yaw,
                pitch: targetAttitude.pitch - userAttitude.pitch)
        let targetDirectionAcceleration: Double =
                userAcceleration.x * cos(relativeAttitude.yaw) * cos(relativeAttitude.pitch)
                        + userAcceleration.y * cos(relativeAttitude.yaw) * cos(relativeAttitude.roll)
                        + userAcceleration.z * cos(relativeAttitude.pitch) * cos(relativeAttitude.roll)
        return TargetDirectionAccelerationAndRelativeAttitude.init(
                targetDirectionAcceleration: targetDirectionAcceleration,
                relativeAttitude: relativeAttitude
        )
    }
}


struct TargetDirectionAccelerationAndRelativeAttitude {
    let targetDirectionAcceleration: Double
    let relativeAttitude: Attitude
}




