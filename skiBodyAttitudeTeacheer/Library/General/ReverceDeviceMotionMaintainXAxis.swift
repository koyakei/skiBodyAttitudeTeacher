//
// Created by koyanagi on 2021/11/18.

import Foundation
import CoreMotion

struct 裏返しにしたDeviceMotionを表にする {
    static func handle(deviceMotion: CMDeviceMotion,
        timeStamp:
            TimeInterval) ->
            MovingPhase {
        MovingPhase.init(boardRidingPhoneAttitudeConverter(attitude:
                                                           deviceMotion.attitude), boardRidingPhoneRotationRateConverter(rotationRate: deviceMotion.rotationRate),
                         accelerationConverter(acceleration: deviceMotion
                                                .userAcceleration), timeStamp, deviceMotion.sensorLocation
        )
    }

    //裏側においたとき ひっくり返す。
    // 裏返し　roll 反転　pitch 反転 yaw 反転
    // roll だけ上下にひっくり返す 姿勢
    static func boardRidingPhoneAttitudeConverter(attitude:
        CMAttitude)
                    -> Attitude {
        Attitude.init(roll: (Double.pi - attitude.roll),
                      yaw: attitude.yaw * -1,
                      pitch: attitude.pitch
                              * -1)
    }

    // 角速度
    static func boardRidingPhoneRotationRateConverter
(rotationRate: CMRotationRate) -> CMRotationRate {
        CMRotationRate.init(
                x: rotationRate.x * -1,
                y: rotationRate.y,
                z: rotationRate.z * -1
        )
    }

    // 加速度
    static func accelerationConverter(acceleration:
            CMAcceleration) -> CMAcceleration {
        CMAcceleration.init(x: acceleration.x * -1, y:
        acceleration.y
                , z: acceleration.z * -1
        )
    }
}
