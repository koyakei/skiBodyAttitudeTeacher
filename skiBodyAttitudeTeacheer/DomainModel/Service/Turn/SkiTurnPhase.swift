//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct SkiTurnPhase {
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

    let turnYawingSide: TurnYawingSide
    let turnSwitchingDirection: TurnSwitchingDirection
    let turnSideChangePeriod: TimeInterval
    let absoluteFallLineAttitude: Attitude
    let turnPhase: TurnChronologicalPhase
    let fallLineOrthogonalAccelerationAndRelativeAttitude:
            TargetDirectionAccelerationAndRelativeAttitude

    let timeStampSince1970: TimeInterval

    let rotationRate: CMRotationRate
}



