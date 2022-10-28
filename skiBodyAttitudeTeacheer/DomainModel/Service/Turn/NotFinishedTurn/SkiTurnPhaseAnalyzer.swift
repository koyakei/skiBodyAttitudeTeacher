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

struct SkiTurnPhaseAnalyzer {
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()
    var absoluteQuaternionFallLineFinder: AbsoluteQuaternionFallLineFinder = AbsoluteQuaternionFallLineFinder.init()
    var oneTurnDiffreentialFinder: OneTurnDiffrentialFinder = OneTurnDiffrentialFinder.init()
    var turnSwitchingTimingFinder: TurnSwitchingTimingFinder = TurnSwitchingTimingFinder.init()
    var lastTurnSwitchingAngle: simd_quatf = simd_quatf.init()
    var turnInFirstPhaseBorder: TurnInFirstPhaseBorder = TurnInFirstPhaseBorder.init()
    var turnDiffrencialFinder: TurnDiffrencialFinder = TurnDiffrencialFinder.init()
    mutating func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {
        let currentFloatQuatanion: simd_quatf =
        simd_quatf.init(ix: Float(movingPhase.quaternion.vector.x), iy: Float(movingPhase.quaternion.vector.y), iz: Float(movingPhase.quaternion.vector.z), r: Float(movingPhase.quaternion.vector.w))
        let isTurnSwitching: Bool = turnSwitchingTimingFinder.handle(cMRotationRate: movingPhase.absoluteRotationRate, timeInterval: movingPhase.timeStampSince1970)
        MotionAnalyzerManager.shared.turnSwitch = isTurnSwitching
        let oneTurnDiffAngleEuller = oneTurnDiffreentialFinder.handle(isTurnSwitched: isTurnSwitching, currentTurnSwitchAngle: currentFloatQuatanion)
        
        if isTurnSwitching {
            lastTurnSwitchingAngle = currentFloatQuatanion
            turnDiffrencialFinder.turnswitchedRecive(movingPhase: movingPhase)
        }
        let turnPhaseBy100 = FindTurnPhaseBy100.init().handle(currentRotationEullerAngleFromTurnSwitching: CurrentDiffrentialFinder.init().handle(lastTurnSwitchAngle: lastTurnSwitchingAngle, currentQuaternion: currentFloatQuatanion), oneTurnDiffrentialAngle: oneTurnDiffAngleEuller)
        let turnSwitchingDirection: TurnSwitchingDirection = turnSwitchingDirectionFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: movingPhase.absoluteRotationRate.yawingSide)
        let turnSideChangePeriod : TimeInterval = turnSideChangingPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, isTurnSwitching: isTurnSwitching)
        
        let absoluteFallLineQuaternion: simd_quatd = absoluteQuaternionFallLineFinder.handle(quaternion: movingPhase.quaternion, timeStampSince1970: movingPhase.timeStampSince1970, yawingPeriod: turnSideChangePeriod)
        let euller = QuaternionToEullerAngleDifferential.convertToEuller(simdq: simd_quatf.init(
            ix: Float(absoluteFallLineQuaternion.vector.x), iy: Float(absoluteFallLineQuaternion.vector.y), iz: Float(absoluteFallLineQuaternion.vector.z), r: Float(absoluteFallLineQuaternion.vector.w)))
        let fallLineAttitude: Attitude = Attitude.init(roll: Double(euller.y), yaw: Double(euller.z), pitch: Double(euller.x))

        let fallLineOrthogonalAccelerationAndRelativeAttitude:
                TargetDirectionAccelerationAndRelativeAttitude
                =
        FallLineOrthogonalAccelerationCalculator.handle(absoluteFallLineAttitude: fallLineAttitude, absoluteFallLineQuaternion: absoluteFallLineQuaternion, turnYawingSide: movingPhase.absoluteRotationRate.yawingSide, userAcceleration: movingPhase.absoluteUserAcceleration, userQuaternion: movingPhase.quaternion, userAttitude: movingPhase.attitude)
        let fallLineAcceleration = AccelerationForTargetAngle.getAcceleration(userAcceleration: movingPhase.absoluteUserAcceleration,
                                          userAttitude: movingPhase.quaternion, targetAttitude: absoluteFallLineQuaternion)
        let skiTurnPhase = SkiTurnPhase.init(turnYawingSide: movingPhase.absoluteRotationRate.yawingSide, turnSwitchingDirection: turnSwitchingDirection,
                                            turnSideChangePeriod: turnSideChangePeriod, absoluteFallLineAttitude: absoluteFallLineQuaternion,
                                                   fallLineAcceleration: fallLineAcceleration,
                                            orthogonalAccelerationAndRelativeAttitude: fallLineOrthogonalAccelerationAndRelativeAttitude,
                                                   absoluteAttitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970, absoluteAcceleration: movingPhase.absoluteUserAcceleration,
                                             rotationRate: movingPhase.absoluteRotationRate, fallLineAttitude: fallLineAttitude, turnPhaseBy100: turnPhaseBy100 ,lastSwitchedTurnAngle: lastTurnSwitchingAngle,
                                             currentAttitude: movingPhase.quaternion, yawingDiffrencialFromIdealYaw: Double( turnDiffrencialFinder.currentIdealDiffrencial(currentAngle: movingPhase.quaternion, currentTime: movingPhase.timeStampSince1970)))
        if turnInFirstPhaseBorder.handle(isTurnSwitching: isTurnSwitching, turnPhaseBy100: Float(turnPhaseBy100),angleRange: Float(0.32)..<Float(0.33)) {
            MotionAnalyzerManager.shared.skiTurn1to3()
        }
        if turnInFirstPhaseBorder.handle(isTurnSwitching: isTurnSwitching, turnPhaseBy100: Float(turnPhaseBy100),angleRange: Float(0.49)..<Float(0.50)) {
            MotionAnalyzerManager.shared.skiTurnMax()
        }
        
        
        return skiTurnPhase
    }
}

extension simd_quatd {
    
    public static func + (lhs: simd_quatd, rhs: simd_quatf) -> simd_quatf{
        return simd_quatf(  lhs) + rhs
    }
    
    public static func - (lhs: simd_quatd, rhs: simd_quatf) -> simd_quatf{
        return simd_quatf(  lhs) - rhs
    }
}

extension simd_quatf {
    public init(_ val: simd_quatd){
        self.init(ix: Float(val.vector.x), iy: Float(val.vector.y), iz: Float(val.vector.z), r: Float(val.vector.w) )
    }
    
    public static func + (lhs: simd_quatf, rhs: simd_quatd) -> simd_quatf{
        return simd_quatf( rhs) + lhs
    }
    
    public static func - (lhs: simd_quatf, rhs: simd_quatd) -> simd_quatf{
        return simd_quatf( rhs) - lhs
    }
}

