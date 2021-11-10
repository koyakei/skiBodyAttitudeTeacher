//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion
struct TurnPhase: TurnPhaseYawSimpleRotationRateAverageProtocol{
    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
         turnFinished: Bool,
         turnSideDirectionChanged: Bool,
         turnPhaseRatio: Float,
         isTurnMax: Bool,
         yawRotationRateMovingAverage: Double
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
    }
    let turnPhaseRatio: Float
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

struct MovingPhaseYawSimpleRotationRateAverage: TurnPhaseYawSimpleRotationRateAverageProtocol{

    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
        turnFinished: Bool,
         turnSideDirectionChanged: Bool
    ) {
        self.movingAverageYawAngle = movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.turnFinished = turnFinished
        self.turnSideDirectionChanged = turnSideDirectionChanged
    }
    var turnFinished: Bool
    var turnSideDirectionChanged: Bool
    var attitude: Attitude

    var userAcceleration: CMAcceleration

    var timeStampSince1970: TimeInterval

    var rotationRate: CMRotationRate
    var movingAverageYawAngle: Double
    var rotationRateAverage: Double
}


struct TurnPhaseWithRotationRateXDirection:TurnPhaseWithRotationRateXDirectionProtocol{
    init(movingPhaseProtocol: MovingPhaseProtocol, movingAverageYawAngle: Double,
         rotationRateXDirection: TurnSide,
         turnSideChanged:Bool) {
        self.movingAverageYawAngle = movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.rotationRateXDirection = rotationRateXDirection
        self.turnSideChanged = turnSideChanged
    }
    var turnSideChanged: Bool
    var rotationRateXDirection: TurnSide

    var attitude: Attitude

    var userAcceleration: CMAcceleration

    var timeStampSince1970: TimeInterval

    var rotationRate: CMRotationRate
    var movingAverageYawAngle: Double
    var rotationRateAverage: Double
}


struct TurnPhaseWithRotationRateXDirectionChangePeriod:TurnPhaseWithRotationRateXDirectionChangePeriodProtocol{
    init(movingPhaseProtocol: TurnPhaseWithRotationRateXDirection,
         rotationRateXDirection: TurnSide,
         rotationRateDirectionChangePeriod: MilliSecond) {
        self.movingAverageYawAngle = movingPhaseProtocol.movingAverageYawAngle
        attitude = movingPhaseProtocol.attitude
        userAcceleration = movingPhaseProtocol.userAcceleration
        timeStampSince1970 = movingPhaseProtocol.timeStampSince1970
        rotationRate = movingPhaseProtocol.rotationRate
        self.rotationRateXDirection = rotationRateXDirection
        self.rotationRateDirectionChangePeriod = rotationRateDirectionChangePeriod
    }
    var rotationRateXDirection: TurnSide

    var attitude: Attitude

    var userAcceleration: CMAcceleration

    var timeStampSince1970: TimeInterval

    var rotationRate: CMRotationRate
    var movingAverageYawAngle: Double
    var rotationRateAverage: Double
    var rotationRateDirectionChangePeriod: MilliSecond
}