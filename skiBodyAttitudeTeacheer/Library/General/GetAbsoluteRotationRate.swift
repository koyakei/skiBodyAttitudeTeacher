//
// Created by koyanagi on 2021/11/18.
// 地軸に対して絶対  attitude yaw 0 pitch 0 roll 0
// のときの 角速度を算出

import Foundation
import CoreMotion

struct GetAbsoluteRotationRate {
    static func handle(rotationRate: CMRotationRate, attitude: Attitude) -> CMRotationRate {
        CMRotationRate.init(
                x: cos(attitude.roll) * rotationRate.x + sin(attitude.roll) * rotationRate.z,
                y: rotationRate.y,
                z: cos(attitude.roll) * rotationRate.z + sin(attitude.roll) * rotationRate.x)
    }
}
