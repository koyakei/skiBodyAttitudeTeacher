//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct SkiTurnPhase: TurnPhaseProtocol {
//    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
//         turnFinished: Bool,
//         turnSideDirectionChanged: Bool,
//         turnPhaseRatio: Float,
//         isTurnMax: Bool,
//         yawRotationRateMovingAverage: Double,
//         fallLineOrthogonalAcceleration: Double,
//         fallLineOrthogonalRelativeAttitude: Attitude,
//         fallLineAcceleration: Double
//    ) {
//        self.movingAverageYawAngle = movingAverageYawAngle
//        attitude = movingPhaseProtocol.attitude
//        userAcceleration = movingPhaseProtocol.userAcceleration
//        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
//        rotationRate = movingPhaseProtocol.rotationRate
//        self.turnFinished = turnFinished
//        self.turnSideDirectionChanged = turnSideDirectionChanged
//        self.turnPhaseRatio = turnPhaseRatio
//        self.isTurnMax = isTurnMax
//        self.yawRotationRateMovingAverage = yawRotationRateMovingAverage
//        self.fallLineOrthogonalAcceleration = fallLineOrthogonalAcceleration
//        self.fallLineOrthogonalRelativeAttitude = fallLineOrthogonalRelativeAttitude
//        rotationRate = movingPhaseProtocol.rotationRate
//        self.fallLineAcceleration = fallLineAcceleration
//    }

    let turnPhaseRatio: Float
    let turnFinished: Bool
    let turnSideDirectionChanged: Bool
    let isTurnMax: Bool
    let yawRotationRateMovingAverage: Double
    let sensorLocation: CMDeviceMotion.SensorLocation

    var turnSideDirection: Bool{
        get {
            yawRotationRateMovingAverage.sign == .minus
        }
    }
    let attitude: Attitude

    let userAcceleration: CMAcceleration

    let timeStampSince1970: TimeInterval
    let rotationRate: CMRotationRate
    let movingAverageYawAngle: Double
    let rotationRateAverage: Double
    let fallLineOrthogonalAcceleration: Double
    let fallLineAcceleration: Double
    let fallLineOrthogonalRelativeAttitude: Attitude
}



