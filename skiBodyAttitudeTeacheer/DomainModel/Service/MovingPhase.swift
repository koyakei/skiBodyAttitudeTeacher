//
//  TurnPhase.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/29.
//

import Foundation
import CoreMotion

public struct MovingPhase: MovingPhaseProtocol {
    let attitude: Attitude
    let userAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let rotationRate: CMRotationRate
    let absoluteRotationRate: CMRotationRate // 重力方向に対する角速度

    init(_ motion: CMDeviceMotion,
         _ timeStampSince1970: TimeInterval) {
        rotationRate = motion.rotationRate
        userAcceleration = motion.userAcceleration
        self.timeStampSince1970 = timeStampSince1970
        attitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw, pitch: motion.attitude.pitch)
        absoluteRotationRate = GetAbsoluteRotationRate
                .handle(rotationRate: rotationRate,
                       attitude: attitude)
    }

    init(movingPhase: MovingPhaseProtocol,
         attitude: Attitude,
         rotationRate: CMRotationRate) {
        self.attitude = attitude
        userAcceleration = movingPhase.userAcceleration
        timeStampSince1970 = movingPhase.timeStampSince1970
        self.rotationRate = rotationRate
        absoluteRotationRate = GetAbsoluteRotationRate
                .handle(rotationRate: rotationRate,
                        attitude: attitude)
    }

    init(_ attitude:Attitude,
         _ rotationRate: CMRotationRate,
         _ acceleration: CMAcceleration,
         _ timeStampSince1970: TimeInterval){
        self.timeStampSince1970 = timeStampSince1970
        self.rotationRate = rotationRate
        userAcceleration = acceleration
        self.attitude = attitude
        absoluteRotationRate = GetAbsoluteRotationRate
                .handle(rotationRate: rotationRate,
                        attitude: attitude)
    }
}





