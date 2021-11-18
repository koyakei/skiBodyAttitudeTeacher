//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct SkiTurnPhase: TurnPhaseYawSimpleRotationRateAverageProtocol {
    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
         turnFinished: Bool,
         turnSideDirectionChanged: Bool,
         turnPhaseRatio: Float,
         isTurnMax: Bool,
         yawRotationRateMovingAverage: Double,
         fallLineOrthogonalAcceleration: Double,
         fallLineOrthogonalRelativeAttitude: Attitude,
         fallLineAcceleration: Double
    ) {
        self.movingAverageYawAngle = movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.turnFinished = turnFinished
        self.turnSideDirectionChanged = turnSideDirectionChanged
        self.turnPhaseRatio = turnPhaseRatio
        self.isTurnMax = isTurnMax
        self.yawRotationRateMovingAverage = yawRotationRateMovingAverage
        self.fallLineOrthogonalAcceleration = fallLineOrthogonalAcceleration
        self.fallLineOrthogonalRelativeAttitude = fallLineOrthogonalRelativeAttitude
        absoluteRotationRate = movingPhaseProtocol.absoluteRotationRate
        self.fallLineAcceleration = fallLineAcceleration
    }

    let turnPhaseRatio: Float
    let turnFinished: Bool
    let turnSideDirectionChanged: Bool
    let isTurnMax: Bool
    let yawRotationRateMovingAverage: Double

    var turnSideDirection: Bool{
        get {
            yawRotationRateMovingAverage.sign == .minus
        }
    }
    let attitude: Attitude

    let userAcceleration: CMAcceleration

    let timeStampSince1970: TimeInterval
    let absoluteRotationRate: CMRotationRate
    let rotationRate: CMRotationRate
    let movingAverageYawAngle: Double
    let rotationRateAverage: Double
    let fallLineOrthogonalAcceleration: Double
    let fallLineAcceleration: Double
    let fallLineOrthogonalRelativeAttitude: Attitude
}

struct CenterOfMassTurnPhase: MovingPhaseProtocol {
    var absoluteRotationRate: CMRotationRate

    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
         turnFinished: Bool,
         turnSideDirectionChanged: Bool,
         isTurnMax: Bool,
         yawRotationRateMovingAverage: Double,
         rotationRateDirectionChangePeriod: TimeInterval
    ) {
        self.movingAverageYawAngle = movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.turnFinished = turnFinished
        self.turnSideDirectionChanged = turnSideDirectionChanged
        self.isTurnMax = isTurnMax
        self.yawRotationRateMovingAverage = yawRotationRateMovingAverage
        absoluteRotationRate = movingPhaseProtocol.absoluteRotationRate
    }

    let turnFinished: Bool
    let turnSideDirectionChanged: Bool
    let isTurnMax: Bool
    let yawRotationRateMovingAverage: Double
    let attitude: Attitude

    let userAcceleration: CMAcceleration

    let timeStampSince1970: TimeInterval

    let rotationRate: CMRotationRate
    let movingAverageYawAngle: Double
    let rotationRateAverage: Double
}

struct CenterOfMassUnifiedTurnPhase: TurnPhaseYawSimpleRotationRateAverageProtocol {
    var fallLineOrthogonalRelativeAttitude: Attitude{
        get {
            if timeStampAndRotationRateXDirectionSideCollection.last!.turnSideDirection {
                //右ターンのとき
                AngleShifter.handle(currentAngle: fallLineYawAttitude, shiftAngle: (Double.pi / 2 * -1))
            } else {
                // 左ターンのとき
                AngleShifter.handle(currentAngle: fallLineYawAttitude, shiftAngle: Double.pi / 2)// 右９０度
            }
        }
    }


    // 重心の加速度　とスキーの直角方向を計算
    var fallLineOrthogonalAcceleration: Double{
        get {
            AccelerationForTargetAngle.handle(
                    userAcceleration: userAcceleration,
                    userAttitude: attitude, targetAttitude: Attitude.init(roll: 0,
                    yaw: yawRotationRateMovingAverage, pitch: 0)
            ).targetDirectionAcceleration
        }
    }

    var absoluteRotationRate: CMRotationRate
    var fallLineAcceleration: Double
    let turnSideDirection: Bool
    init(skiTurnPhase: TurnPhase,
         centerOfMassTurnPhase: CenterOfMassTurnPhase
    ) {
        movingAverageYawAngle = centerOfMassTurnPhase.yawRotationRateMovingAverage
        attitude = centerOfMassTurnPhase.attitude
        userAcceleration = centerOfMassTurnPhase.userAcceleration
        timeStampSince1970 = centerOfMassTurnPhase.timeStampSince1970
        rotationRate = centerOfMassTurnPhase.rotationRate
        turnFinished = skiTurnPhase.turnFinished
        turnSideDirectionChanged = skiTurnPhase.turnSideDirectionChanged
        isTurnMax = skiTurnPhase.isTurnMax
        yawRotationRateMovingAverage = skiTurnPhase.yawRotationRateMovingAverage
        absoluteRotationRate = centerOfMassTurnPhase.absoluteRotationRate
        turnSideDirection = skiTurnPhase.
    }

    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
         turnFinished: Bool,
         turnSideDirectionChanged: Bool,
         isTurnMax: Bool,
         yawRotationRateMovingAverage: Double,
         fallLineOrthogonalAcceleration: Double,
         fallLineOrthogonalRelativeAttitude: Attitude
    ) {
        self.movingAverageYawAngle = movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.turnFinished = turnFinished
        self.turnSideDirectionChanged = turnSideDirectionChanged
        self.isTurnMax = isTurnMax
        self.yawRotationRateMovingAverage = yawRotationRateMovingAverage
        absoluteRotationRate = movingPhaseProtocol.absoluteRotationRate
    }

    let turnFinished: Bool
    let turnSideDirectionChanged: Bool
    let isTurnMax: Bool
    let yawRotationRateMovingAverage: Double
    let attitude: Attitude

    let userAcceleration: CMAcceleration

    let timeStampSince1970: TimeInterval

    let rotationRate: CMRotationRate
    let movingAverageYawAngle: Double
    let rotationRateAverage: Double
}