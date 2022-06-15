//
// Created by koyanagi on 2021/11/30.
//

import Foundation
import CoreMotion
import simd

struct AccelerationShifter {
    let relativeAcceleration: CMAcceleration
    let relativeAttitude: Attitude

    // reelative attitute y 方向の加速度
    func handle() -> Double {
        (relativeAcceleration.x * sin(relativeAttitude.yaw * -1)) +
                (relativeAcceleration.y * cos(relativeAttitude.yaw * -1))
                +
                (relativeAcceleration.z * sin(relativeAttitude.pitch * -1)
                        + (relativeAcceleration.y * sin(relativeAttitude.pitch * -1)))
    }
}

struct AccelerationShifterQuota {
    let relativeAcceleration: CMAcceleration
    let relativeAttitude: CMQuaternion

    //    func handle() -> Double{
    //
    //    }

}
