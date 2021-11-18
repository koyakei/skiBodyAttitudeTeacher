//
// Created by koyanagi on 2021/11/18.
//

import Foundation

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