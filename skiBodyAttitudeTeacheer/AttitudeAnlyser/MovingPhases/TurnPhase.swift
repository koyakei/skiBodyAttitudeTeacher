//
//  TurnPhase.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/29.
//

import Foundation
import CoreMotion

struct TurnPhase: TurnPhaseProtocol{

    let attitude: Attitude
    let userAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let rotationRate: CMRotationRate
    
    init(_ motion: CMDeviceMotion,
         _ timeStampSince1970: TimeInterval){
        self.rotationRate = motion.rotationRate
        userAcceleration.z = motion.userAcceleration.z
        userAcceleration.y = motion.userAcceleration.y
        userAcceleration.x = motion.userAcceleration.x
        self.timeStampSince1970 = timeStampSince1970
        attitude = Attitude.init(roll: motion.attitude.roll, yaw: motion.attitude.yaw, pitch:motion.attitude.pitch)
    }
    
    init(turnPhase: TurnPhase, attitude: Attitude, rotationRate: CMRotationRate){
        self.attitude = attitude
        self.userAcceleration.z = turnPhase.userAcceleration.z
        self.userAcceleration.y = turnPhase.userAcceleration.y
        self.userAcceleration.x = turnPhase.userAcceleration.x
        self.timeStampSince1970 = turnPhase.timeStampSince1970
        self.rotationRate = rotationRate
    }
}



struct SkiTurnPhaseWithFallLineAttitude :TurnPhaseProtocol{
    let attitude: Attitude
    let userAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let rotationRate: CMRotationRate
    let skiFallLineAcceleration: Double
    let fallLineAbsoluteAttitude: Attitude
    let fallLineRelativeAttitude: Attitude
    init (turnPhase: TurnPhaseProtocol, fab: Attitude){
        fallLineRelativeAttitude = Attitude.init(roll: fab.roll - currentAttitude.roll, yaw: fab.yaw - currentAttitude.yaw,
                pitch: fab.pitch - currentAttitude.pitch)
        skiFallLineAcceleration = fallLineAcceleration(currentAcceleration: turnPhase.userAcceleration, relativeFallLineAttitude: fab)
    }
    // fall line の方向への加速度を計算
    func fallLineAcceleration(
        currentAcceleration: CMAcceleration,
        relativeFallLineAttitude: Attitude
    )-> Double{
        let x = currentAcceleration.x * cos(        relativeFallLineAttitude.yaw)   * cos(        relativeFallLineAttitude.pitch)
        let y = currentAcceleration.y * cos(        relativeFallLineAttitude.yaw)   * cos(        relativeFallLineAttitude.roll)
        let z = currentAcceleration.z * cos(        relativeFallLineAttitude.pitch)   * cos(        relativeFallLineAttitude.roll)
        return x + y + z
    }
    
    func relativeFallLineAttitude(
            fab: Attitude,
        currentAttitude: Attitude
    )-> Attitude {

    }
}
struct Attitude{
    let roll : Double
    let yaw: Double
    let pitch: Double
}


