//
//  TurnPhase.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/29.
//

import Foundation
import CoreMotion
public struct AirPodMovingPhase: MovingPhaseProtocol {
    let absoluteAttitude: Attitude
    let 磁北偏差 : Double
    let attitude: Attitude
    let absoluteUserAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let absoluteRotationRate: CMRotationRate
    let sensorLocation: CMDeviceMotion.SensorLocation
    let timeStamp: Date
    init(_ motion: CMDeviceMotion,
         _ timeStampSince1970: TimeInterval,
         _ 磁北偏差: Double) {
        absoluteRotationRate = motion.rotationRate
        absoluteUserAcceleration = motion.userAcceleration
        self.timeStampSince1970 = timeStampSince1970
        absoluteAttitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw + 磁北偏差, pitch: motion.attitude.pitch)
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
        sensorLocation = motion.sensorLocation
        attitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw , pitch: motion.attitude.pitch)
        self.磁北偏差 = 磁北偏差
    }
}

public struct MovingPhase: MovingPhaseProtocol {
    let attitude: Attitude
    let absoluteUserAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let absoluteRotationRate: CMRotationRate
    let timeStamp : Date
    let sensorLocation: CMDeviceMotion.SensorLocation
    init(_ motion: CMDeviceMotion,
         _ timeStampSince1970: TimeInterval) {
        absoluteRotationRate = motion.rotationRate
        absoluteUserAcceleration = motion.userAcceleration
        self.timeStampSince1970 = timeStampSince1970
        attitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw, pitch: motion.attitude.pitch)
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
        sensorLocation = motion.sensorLocation
    }
    


    init(movingPhase: MovingPhaseProtocol,
         attitude: Attitude,
         rotationRate: CMRotationRate) {
        self.attitude = attitude
        absoluteUserAcceleration = movingPhase.absoluteUserAcceleration
        timeStampSince1970 = movingPhase.timeStampSince1970
        self.absoluteRotationRate = rotationRate
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
        sensorLocation = movingPhase.sensorLocation
    }

    init(_ attitude:Attitude,
         _ rotationRate: CMRotationRate,
         _ acceleration: CMAcceleration,
         _ timeStampSince1970: TimeInterval,
         _ sensorLocation: CMDeviceMotion.SensorLocation){
        self.timeStampSince1970 = timeStampSince1970
        self.absoluteRotationRate = rotationRate
        absoluteUserAcceleration = acceleration
        self.attitude = attitude
        timeStamp = Date(timeIntervalSince1970: timeStampSince1970)
        self.sensorLocation = sensorLocation
    }
}





