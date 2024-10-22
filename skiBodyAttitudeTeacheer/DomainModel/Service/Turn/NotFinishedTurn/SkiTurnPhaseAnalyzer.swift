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

class SkiTurnPhaseAnalyzer : ObservableObject{
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()
    var absoluteQuaternionFallLineFinder: AbsoluteQuaternionFallLineFinder = AbsoluteQuaternionFallLineFinder.init()
    var oneTurnDiffreentialFinder: OneTurnDiffrentialFinder = OneTurnDiffrentialFinder.init()
    var turnSwitchingTimingFinder: TurnSwitchingTimingFinder = TurnSwitchingTimingFinder.init()
    var lastTurnSwitchingAngle: simd_quatf = simd_quatf.init()
    var turnInFirstPhaseBorder: TurnInFirstPhaseBorder = TurnInFirstPhaseBorder.init()
    var turnDiffrencialFinder: TurnDiffrencialFinder = TurnDiffrencialFinder.init()
    var beforeMovingPhaseTimeStamp : TimeInterval = 0
    var currentVelocityToSkiTopOrientation : CurrentVelocity = CurrentVelocity.init(initalSpeed: 0)
    var currentFallLineOrthogonalVelocityCalitulator: CurrentVelocity = CurrentVelocity.init(initalSpeed: 0)
//    var 現在の相対速度をターン開始を０として設定 : Float = 0
    var 現在までの最高速度とそのターンフェイズの情報 : SkiTurnPhase?
    var beforeSkiTurnPhase : SkiTurnPhase?
    var minimumFallLineOrthogonalVelocityInStartOfTurnCaliculator = MinimumFallLineOrthogonalVelocityInStartOfTurnCaliculator.init(minVelocity: 0)
    var isMaxSkiTurnPhaseByAngleFinder  = SkiTurnPhaseByAngleFinder.init()
//    var 現在までの最低速度とそのターンフェイズの情報: SkiTurnPhase
    // 前のターンの最大速度からの　ターン前半　外転角の大きさが大きいうちに外側方向への原則が大きいかどうか
    var ターン前半で作ったタメ : Double = 0
    var 前回ターン切り替え時の横移動速度 : Double = 0
    func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {
        let currentFloatQuatanion: simd_quatf =
        simd_quatf.init(ix: Float(movingPhase.quaternion.vector.x), iy: Float(movingPhase.quaternion.vector.y), iz: Float(movingPhase.quaternion.vector.z), r: Float(movingPhase.quaternion.vector.w))
        let isTurnSwitching: Bool = turnSwitchingTimingFinder.handle(cMRotationRate: movingPhase.absoluteRotationRate, timeInterval: movingPhase.timeStampSince1970)
        MotionAnalyzerManager.shared.turnSwitch = isTurnSwitching
        let oneTurnDiffAngleEuller = oneTurnDiffreentialFinder.handle(isTurnSwitched: isTurnSwitching, currentTurnSwitchAngle: currentFloatQuatanion)
        
        if isTurnSwitching {
            lastTurnSwitchingAngle = currentFloatQuatanion
            turnDiffrencialFinder.turnswitchedRecive(movingPhase: movingPhase)
            currentVelocityToSkiTopOrientation.initalSpeed = 0
        }
        let cuurentVelocityToSkiTop = currentVelocityToSkiTopOrientation.handle(currentAcceleration: movingPhase.absoluteUserAcceleration.y, currentiTimestamp: movingPhase.timeStampSince1970, beforeMovingPhaseTimeStamp: beforeMovingPhaseTimeStamp)
       
        let 今の減衰率 =  cuurentVelocityToSkiTop / 現在までの最高速度とそのターンフェイズの情報!.currentVelocityToSkiTop
        let turnPhasePercantageByAngle = FindTurnPhaseBy100.init().handle(currentRotationEullerAngleFromTurnSwitching: CurrentDiffrentialFinder.init().handle(lastTurnSwitchAngle: lastTurnSwitchingAngle, currentQuaternion: currentFloatQuatanion), oneTurnDiffrentialAngle: oneTurnDiffAngleEuller)
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
        let currentFallLineOrthogonalVelocity = currentFallLineOrthogonalVelocityCalitulator.handle(currentAcceleration: fallLineOrthogonalAccelerationAndRelativeAttitude.targetDirectionAcceleration, currentiTimestamp: movingPhase.timeStampSince1970 , beforeMovingPhaseTimeStamp: beforeMovingPhaseTimeStamp)
        if isTurnSwitching{
            前回ターン切り替え時の横移動速度 = currentFallLineOrthogonalVelocity
        }
        if turnPhasePercantageByAngle < 0.5 { // 谷まわりだったらにするべきだがターン前半でもバグらないはず。ヘアピントンネルとか１８０ど曲がると問題が起きる。
            minimumFallLineOrthogonalVelocityInStartOfTurnCaliculator.handle(currentOrthogonalVelocity: currentFallLineOrthogonalVelocity)
        }
        let ゴール方向に向いているか？ = isMaxSkiTurnPhaseByAngleFinder.handle(currentTurnAnglePhasePercentage: turnPhasePercantageByAngle, currentTimeStamp: movingPhase.timeStampSince1970)
        if ゴール方向に向いているか？ { //ターンマックスで横移動速度をリセット
            currentFallLineOrthogonalVelocityCalitulator.initalSpeed = 0
            ターン前半で作ったタメ = minimumFallLineOrthogonalVelocityInStartOfTurnCaliculator.minVelocity /    前回ターン切り替え時の横移動速度
        }
        let fallLineAcceleration = AccelerationForTargetAngle.getAcceleration(userAcceleration: movingPhase.absoluteUserAcceleration,
                                          userAttitude: movingPhase.quaternion, targetAttitude: absoluteFallLineQuaternion)
        let idealYaw = turnDiffrencialFinder.currentIdealDiffrencial(currentAngle: movingPhase.quaternion, currentTime: movingPhase.timeStampSince1970)
        let perTime = turnDiffrencialFinder.currentTimeDurationPercentage(currentTime: movingPhase.timeStampSince1970)
        let skiTurnPhase = SkiTurnPhase.init(turnYawingSide: movingPhase.absoluteRotationRate.yawingSide, turnSwitchingDirection: turnSwitchingDirection,
                                            turnSideChangePeriod: turnSideChangePeriod, absoluteFallLineAttitude: absoluteFallLineQuaternion,
                                                   fallLineAcceleration: fallLineAcceleration,
                                            orthogonalAccelerationAndRelativeAttitude: fallLineOrthogonalAccelerationAndRelativeAttitude,
                                                   absoluteAttitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970, absoluteAcceleration: movingPhase.absoluteUserAcceleration,
                                             rotationRate: movingPhase.absoluteRotationRate, fallLineAttitude: fallLineAttitude, turnPhaseBy100: turnPhasePercantageByAngle ,lastSwitchedTurnAngle: lastTurnSwitchingAngle,
                                             currentAttitude: movingPhase.quaternion, currentVelocityToSkiTop: cuurentVelocityToSkiTop, yawingDiffrencialFromIdealYaw: Double(idealYaw ), turnPhasePercentageByTime: perTime)
        if 現在までの最高速度とそのターンフェイズの情報 != nil{
            if  cuurentVelocityToSkiTop > 現在までの最高速度とそのターンフェイズの情報!.currentVelocityToSkiTop{
                現在までの最高速度とそのターンフェイズの情報 = skiTurnPhase
            }
        }
        // ターン指導で横にいくタメを作る定義
        if isTurnSwitching {
            let ターンエンドでの減衰率 = 今の減衰率
            // ターンエンドでの速度減衰率をどう返すのか？　今の減衰率を音で表現してもいいだろ
            
        }
        if turnInFirstPhaseBorder.handle(isTurnSwitching: isTurnSwitching, turnPhaseBy100: Float(turnPhasePercantageByAngle),angleRange: Float(0.32)..<Float(0.33)) {
            MotionAnalyzerManager.shared.skiTurn1to3()
        }
        if turnInFirstPhaseBorder.handle(isTurnSwitching: isTurnSwitching, turnPhaseBy100: Float(turnPhasePercantageByAngle),angleRange: Float(0.49)..<Float(0.50)) {
            MotionAnalyzerManager.shared.skiTurnMax()
        }
        
        beforeMovingPhaseTimeStamp = movingPhase.timeStampSince1970
        beforeSkiTurnPhase = skiTurnPhase
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

