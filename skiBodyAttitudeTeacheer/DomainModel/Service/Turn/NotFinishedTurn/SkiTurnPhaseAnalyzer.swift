//
//  IdealTurnConditionDetector.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import CoreMotion
import simd
import SceneKit

struct SkiTurnPhaseAnalyzer : TurnPhaseAnalyzerProtocol {
    var turnChronologicalPhaseFinder: TurnChronologicalPhaseFinder = TurnChronologicalPhaseFinder.init()
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()
    var absoluteQuaternionFallLineFinder: AbsoluteQuaternionFallLineFinder = AbsoluteQuaternionFallLineFinder.init()
    var oneTurnDiffreentialFinder: OneTurnDiffrentialFinder = OneTurnDiffrentialFinder.init()
    var turnSwitchingTimingFinder: TurnSwitchingTimingFinder = TurnSwitchingTimingFinder.init()
    var lastTurnSwitchingAngle: simd_quatf = simd_quatf.init()
    var turnInFirstPhaseBorder: TurnInFirstPhaseBorder = TurnInFirstPhaseBorder.init()
    mutating func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {
        let currentFloatQuatanion: simd_quatf =
        simd_quatf.init(ix: Float(movingPhase.quaternion.vector.x), iy: Float(movingPhase.quaternion.vector.y), iz: Float(movingPhase.quaternion.vector.z), r: Float(movingPhase.quaternion.vector.w))
        let isTurnSwitching: Bool = turnSwitchingTimingFinder.handle(cMRotationRate: movingPhase.absoluteRotationRate, timeInterval: movingPhase.timeStampSince1970)
        MotionAnalyzerManager.shared.turnSwitch = isTurnSwitching
        let oneTurnDiffAngleEuller = oneTurnDiffreentialFinder.handle(isTurnSwitched: isTurnSwitching, currentTurnSwitchAngle: currentFloatQuatanion)
        
        if isTurnSwitching {
            lastTurnSwitchingAngle = currentFloatQuatanion
        }
        let turnPhaseBy100 = FindTurnPhaseBy100.init().handle(currentRotationEullerAngleFromTurnSwitching: CurrentDiffrentialFinder.init().handle(lastTurnSwitchAngle: lastTurnSwitchingAngle, currentQuaternion: currentFloatQuatanion), oneTurnDiffrentialAngle: oneTurnDiffAngleEuller)
        let turnSwitchingDirection: TurnSwitchingDirection = turnSwitchingDirectionFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: movingPhase.absoluteRotationRate.yawingSide)
        let turnSideChangePeriod : TimeInterval = turnSideChangingPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, isTurnSwitching: isTurnSwitching)
        
        let absoluteFallLineQuaternion: simd_quatd = absoluteQuaternionFallLineFinder.handle(quaternion: movingPhase.quaternion, timeStampSince1970: movingPhase.timeStampSince1970, yawingPeriod: turnSideChangePeriod)
        let fallLineAttitude: Attitude = QuaternionToEuler.init(q: absoluteFallLineQuaternion).handle()
        
        let turnChronologicalPhase: TurnPhaseByStartMaxEnd = turnChronologicalPhaseFinder.handle(
            currentAttitude: movingPhase.attitude, absoluteFallLineAttitude: fallLineAttitude
        , currentTurnYawingSide: movingPhase.absoluteRotationRate.yawingSide, turnSwitchingDirection: turnSwitchingDirection)
        
        let fallLineOrthogonalAccelerationAndRelativeAttitude:
                TargetDirectionAccelerationAndRelativeAttitude
                =
        FallLineOrthogonalAccelerationCalculator.handle(absoluteFallLineAttitude: fallLineAttitude, absoluteFallLineQuaternion: absoluteFallLineQuaternion, turnYawingSide: movingPhase.absoluteRotationRate.yawingSide, userAcceleration: movingPhase.absoluteUserAcceleration, userQuaternion: movingPhase.quaternion, userAttitude: movingPhase.attitude)
        let fallLineAcceleration = AccelerationForTargetAngle.getAcceleration(userAcceleration: movingPhase.absoluteUserAcceleration,
                                          userAttitude: movingPhase.quaternion, targetAttitude: absoluteFallLineQuaternion)
        let skiTurnPhase = SkiTurnPhase.init(turnYawingSide: movingPhase.absoluteRotationRate.yawingSide, turnSwitchingDirection: turnSwitchingDirection,
                                            turnSideChangePeriod: turnSideChangePeriod, absoluteFallLineAttitude: absoluteFallLineQuaternion,
                                                   fallLineAcceleration: fallLineAcceleration, turnPhase: turnChronologicalPhase,
                                            orthogonalAccelerationAndRelativeAttitude: fallLineOrthogonalAccelerationAndRelativeAttitude,
                                                   absoluteAttitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970, absoluteAcceleration: movingPhase.absoluteUserAcceleration,
                                             rotationRate: movingPhase.absoluteRotationRate, fallLineAttitude: fallLineAttitude, turnPhaseBy100: turnPhaseBy100 ,lastSwitchedTurnAngle: lastTurnSwitchingAngle)
        
        if turnInFirstPhaseBorder.handle(isTurnSwitching: isTurnSwitching, turnPhaseBy100: Float(turnPhaseBy100),angleRange: Float(0.32)..<Float(0.33)) {
            MotionAnalyzerManager.shared.skiTurn1to3()
        }
        if turnChronologicalPhase == .TurnMax{
            MotionAnalyzerManager.shared.skiTurnMax()
        }
        
        return skiTurnPhase
    }
}



