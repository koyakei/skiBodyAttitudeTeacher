//
// Created by koyanagi on 2021/11/18.
// TODO: ここから

import Foundation
import CoreMotion


struct 裏返しにしたDeviceMotionを表にする {
    func handle(deviceMotion: CMDeviceMotion)-> MovingPhase{
        MovingPhase.init(, <#T##timeStampSince1970: TimeInterval##TimeInterval#>)
    }
    //裏側においたとき ひっくり返す。
    // 裏返し　roll 反転　pitch 反転 yaw 反転
    // roll だけ上下にひっくり返す
    func boardRidingPhoneAttitudeConverter(attitude: Attitude) -> Attitude {
        Attitude.init(roll: (Double.pi - attitude.roll) * -1, yaw: attitude.yaw * -1, pitch: attitude.pitch * -1)
    }

    func boardRidingPhoneRotationRateConverter(rotationRate: CMRotationRate) -> CMRotationRate {
        CMRotationRate.init(
                x: rotationRate.x * -1,
                y: rotationRate.y,
                z: rotationRate.z * -1
        )
    }
}
