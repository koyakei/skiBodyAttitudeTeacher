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

struct QuaternionToEuler {
    let q: simd_quatd
    
    private func pitch() -> Double{
        let sinp : Double = 2 * (q.vector.w * q.vector.y - q.vector.z * q.vector.x);
//        if (abs(sinp) >= 1){
//            return copysign(Double.pi / 2, sinp); // use 90 degrees if out of range
//        } else {
            return asin(sinp);
//        }
    }
    func handle() -> Attitude {
        Attitude.init(roll: atan2(2 * (q.vector.w * q.vector.x - q.vector.y * q.vector.z),
                                  1 - 2 * (q.vector.x * q.vector.x + q.vector.y * q.vector.y)),
        yaw: atan2(2 * ((q.vector.w * q.vector.z) + (q.vector.x * q.vector.y)),
                   1 - (2 * (q.vector.y * q.vector.y + q.vector.z * q.vector.z))),
        pitch: pitch())
    }
}

struct AccelerationShifterQuota {
    let relativeAcceleration: CMAcceleration
    let relativeAttitude: CMQuaternion

    //    func handle() -> Double{
    //
    //    }

}
