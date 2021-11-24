//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import CoreMotion
struct CenterOfMassUnifiedTurnPhase: TurnPhaseProtocol {
    var fallLineOrthogonalRelativeAttitude: Attitude{
        get {
            switch turnYawingSideDirection{
            case TurnYawingSide.RightYawing:
                return Attitude.init(roll: 0, yaw: AngleShifter.handle(currentAngle: fallLineAttitude.yaw, shiftAngle: (Double.pi / 2 * -1)), pitch: 0)
            case TurnYawingSide.LeftYawing:
                return Attitude.init(roll: 0, yaw: AngleShifter.handle(currentAngle: fallLineAttitude.yaw, shiftAngle: Double.pi / 2), pitch: 0)// 右９０度
            case .Straight:
                return Attitude.init(roll: 0, yaw: fallLineAttitude.yaw, pitch: 0)
            }
        }
    }
    let fallLineAttitude: Attitude


    // 重心の加速度　とスキーの直角方向を計算
    var fallLineOrthogonalAcceleration: Double
//    {
//        get {
////            AccelerationForTargetAngle.handle(
////                    userAcceleration: userAcceleration,
////                    userAttitude: attitude, targetAttitude: Attitude.init(roll: 0,
////                                                                          yaw: yawRotationRateMovingAverage, pitch: 0)
////            ).targetDirectionAcceleration
//        }
//    }

    var rotationRate: CMRotationRate
    var fallLineAcceleration: Double
    let turnYawingSideDirection: TurnYawingSide
//    init(skiTurnPhase: SkiTurnPhase,
//         centerOfMassTurnPhase: CenterOfMassTurnPhase
//    ) {
//        movingAverageYawAngle = centerOfMassTurnPhase.yawRotationRateMovingAverage
//        attitude = centerOfMassTurnPhase.attitude
//        userAcceleration = centerOfMassTurnPhase.userAcceleration
//        timeStampSince1970 = centerOfMassTurnPhase.timeStampSince1970
//        rotationRate = centerOfMassTurnPhase.rotationRate
//        turnFinished = skiTurnPhase.turnFinished
//        turnSideDirectionChanged = skiTurnPhase.turnSideDirectionChanged
//        isTurnMax = skiTurnPhase.isTurnMax
//        yawRotationRateMovingAverage = skiTurnPhase.yawRotationRateMovingAverage
//        rotationRate = centerOfMassTurnPhase.rotationRate
//        turnSideDirection = skiTurnPhase.
//    }

//    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
//         turnFinished: Bool,
//         turnSideDirectionChanged: Bool,
//         isTurnMax: Bool,
//         yawRotationRateMovingAverage: Double,
//         fallLineOrthogonalAcceleration: Double,
//         fallLineOrthogonalRelativeAttitude: Attitude
//    ) {
//        self.movingAverageYawAngle = movingAverageYawAngle
//        attitude = movingPhaseProtocol.attitude
//        userAcceleration = movingPhaseProtocol.userAcceleration
//        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
//        rotationRate = movingPhaseProtocol.rotationRate
//        self.turnFinished = turnFinished
//        self.turnSideDirectionChanged = turnSideDirectionChanged
//        self.isTurnMax = isTurnMax
//        self.yawRotationRateMovingAverage = yawRotationRateMovingAverage
//        rotationRate = movingPhaseProtocol.rotationRate
//    }

    let turnFinished: Bool
    let turnSideDirectionChanged: Bool
    let isTurnMax: Bool
    let yawRotationRateMovingAverage: Double
    let attitude: Attitude

    let userAcceleration: CMAcceleration

    let timeStampSince1970: TimeInterval
    let movingAverageYawAngle: Double
    let rotationRateAverage: Double
}
