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
    let timeStamp : Date

    init(_ motion: CMDeviceMotion,
         _ timeStampSince1970: TimeInterval) {
        rotationRate = motion.rotationRate
        userAcceleration = motion.userAcceleration
        self.timeStampSince1970 = timeStampSince1970
        attitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw, pitch: motion.attitude.pitch)
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
    }

    init(movingPhase: MovingPhaseProtocol,
         attitude: Attitude,
         rotationRate: CMRotationRate) {
        self.attitude = attitude
        userAcceleration = movingPhase.userAcceleration
        timeStampSince1970 = movingPhase.timeStampSince1970
        self.rotationRate = rotationRate
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
    }

    init(_ attitude:Attitude,
         _ rotationRate: CMRotationRate,
         _ acceleration: CMAcceleration,
         _ timeStampSince1970: TimeInterval){
        self.timeStampSince1970 = timeStampSince1970
        self.rotationRate = rotationRate
        userAcceleration = acceleration
        self.attitude = attitude
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
    }
}





