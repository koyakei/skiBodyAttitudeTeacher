//
//  IdealTurnConditionDetector.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import CoreMotion
import simd
struct SkiTurnPhaseAnalyzer : TurnPhaseAnalyzerProtocol {
    
    var turnChronologicalPhaseFinder: TurnChronologicalPhaseFinder = TurnChronologicalPhaseFinder.init()
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()
    var absoluteQuaternionFallLineFinder: AbsoluteQuaternionFallLineFinder = AbsoluteQuaternionFallLineFinder.init()
    mutating func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {
        let turnYawingSide: TurnYawingSide = movingPhase.absoluteRotationRate.yawingSide
        let turnSwitchingDirection: TurnSwitchingDirection = turnSwitchingDirectionFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let turnSideChangePeriod : TimeInterval = turnSideChangingPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let absoluteFallLineAttitude: simd_quatd = absoluteQuaternionFallLineFinder.handle(quaternion: movingPhase.quaternion, timeStampSince1970: movingPhase.timeStampSince1970, yawingPeriod: turnSideChangePeriod)
        let fallLineAttitude: Attitude = QuaternionToEuler.init(q: absoluteFallLineAttitude).handle()
        let turnChronologicalPhase: TurnChronologicalPhase = turnChronologicalPhaseFinder.handle(
            currentAttitude: movingPhase.attitude, absoluteFallLineAttitude: fallLineAttitude
        , currentTurnYawingSide: turnYawingSide, turnSwitchingDirection: turnSwitchingDirection)
        
        let fallLineOrthogonalAccelerationAndRelativeAttitude:
                TargetDirectionAccelerationAndRelativeAttitude
                =
                FallLineOrthogonalAccelerationCalculator.handle(absoluteFallLineAttitude: absoluteFallLineAttitude, turnYawingSide: turnYawingSide, userAcceleration: movingPhase.absoluteUserAcceleration, userAttitude: movingPhase.quaternion)
        let fallLineAcceleration = AccelerationForTargetAngle.getAcceleration(userAcceleration: movingPhase.absoluteUserAcceleration,
                                          userAttitude: movingPhase.quaternion, targetAttitude: absoluteFallLineAttitude)
        if turnChronologicalPhase == .TurnMax{
            MotionAnalyzerManager.shared.skiTurnMax()
        }
        
        return SkiTurnPhase.init(turnYawingSide: turnYawingSide, turnSwitchingDirection: turnSwitchingDirection,
                          turnSideChangePeriod: turnSideChangePeriod, absoluteFallLineAttitude: absoluteFallLineAttitude,
                                 fallLineAcceleration: fallLineAcceleration, turnPhase: turnChronologicalPhase,
                          orthogonalAccelerationAndRelativeAttitude: fallLineOrthogonalAccelerationAndRelativeAttitude,
                                 absoluteAttitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970, absoluteAcceleration: movingPhase.absoluteUserAcceleration,
                                 rotationRate: movingPhase.absoluteRotationRate, fallLineAttitude: fallLineAttitude)
    }
}



