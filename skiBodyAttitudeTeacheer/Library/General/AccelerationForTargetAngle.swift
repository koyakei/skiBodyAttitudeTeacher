//
// Created by koyanagi on 2021/11/11.
//

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
        TargetDirectionAccelerationAndRelativeAttitude.init(
                targetDirectionAcceleration: targetDirectionAcceleration,
                relativeAttitude: relativeAttitude
        )
    }
}


struct TargetDirectionAccelerationAndRelativeAttitude {
    let targetDirectionAcceleration: Double
    let relativeAttitude: Attitude
}