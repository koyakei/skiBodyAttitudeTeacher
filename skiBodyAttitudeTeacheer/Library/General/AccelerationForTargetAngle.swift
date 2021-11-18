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

struct TurnInsideAngleFinder {
    static func handle(
            turnSideDirection: Bool,
            fallLineYawAngle: Double
    ) -> Double {
        if turnSideDirection {
            //右ターンのとき
            return AngleShifter.handle(currentAngle: fallLineYawAngle, shiftAngle: (Double.pi / 2 * -1))// 右９０度
        } else {
            // 左ターンのとき
            return AngleShifter.handle(currentAngle: fallLineYawAngle, shiftAngle: Double.pi / 2)// 左９０度
        }
    }
}

struct FallLineOrthogonalAccelerationCalculator{
    static func handle(turnSideDirection: Bool,
                       fallLineYawAngle: Double,
                       userAcceleration: CMAcceleration,
                       userAttitude: Attitude
                       ) -> TargetDirectionAccelerationAndRelativeAttitude{
        AccelerationForTargetAngle.handle(
                userAcceleration: userAcceleration,
                userAttitude: userAttitude,
                targetAttitude: Attitude.init(roll: 0, yaw: TurnInsideAngleFinder.handle(
                        turnSideDirection: turnSideDirection,
                        fallLineYawAngle: fallLineYawAngle), pitch: 0)
        )
    }
}