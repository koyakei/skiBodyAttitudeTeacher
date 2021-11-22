//
//  IdealTurnConditionDetector.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation


struct SkiTurnPhaseAnalyzer {
    //        : TurnPhaseAnalyzerProtocol {
    //    var movingPhases: [MovingPhaseProtocol] = []
    // true right to left false left to right
    // plus is right turn
    // minus is left turn
    var turnPhaseFinder: TurnChronologicalPhaseFinder = TurnChronologicalPhaseFinder.init()
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var yawingRotationRateAverageFinder :YawRotationRateMovingAverageFinder = YawRotationRateMovingAverageFinder.init()
    var yawingSideFinder = YawingSideFinder.init()
    var absoluteFallLineAttitudeFinder: AbsoluteFallLineAttitudeFinder =
            AbsoluteFallLineAttitudeFinder.init()
    //    var turnYawingSideFinder = TurnYawing
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()

    mutating func handle(movingPhase:
            MovingPhase) -> (TurnYawingSide,TurnSwitchingDirection,Attitude,Double) {
        let turnYawingSide: TurnYawingSide = YawingSideFinder.handle(currentRotationRate: yawingRotationRateAverageFinder.handle(
            absoluteRotationRate: movingPhase.absoluteRotationRate, timeStampSince1970: movingPhase.timeStampSince1970))
        let turnSwitchingDirection: TurnSwitchingDirection = turnSwitchingDirectionFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let turnSideChangePeriod : Double = turnSideChangingPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let absoluteFallLineAttitude: Attitude = absoluteFallLineAttitudeFinder.handle(attitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970,yawingPeriod: 5)

        return (turnYawingSide,turnSwitchingDirection,absoluteFallLineAttitude ,turnSideChangePeriod)
        // フォールライン方向の加速度を計算
        // 他の指標も計算していく
        // ピボットスリップを計算する前提で考えてみよう
        // 前回のターン切り替えからの偏角は計算するか？　べつにしなくていいか
        // フォールラインと直角方向の加速度を計算
//        let fallLineOrthogonal:
//                TargetDirectionAccelerationAndRelativeAttitude
//                =
//                FallLineOrthogonalAccelerationCalculator.handle(turnSideDirection: turnPhaseFinder.rightTurnFromSwitchTurnSideToEnd, fallLineYawAngle: yawRotationRateMovingAverage, userAcceleration: movingPhase.userAcceleration, userAttitude: movingPhase.attitude)

//        if (turnPhaseType == TurnSwitchRightToLeft
//                || turnPhaseType == TurnSwitchLeftToRight) {
//            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
//            MotionAnalyzerManager.shared.unify()
//        }
//        SkiTurnPhase.init(
//                movingPhaseProtocol: movingPhase,
//                movingAverageYawAngle: yawingSimpleMovingAverage,
//                turnPhaseType: turnPhaseType,
//                turnSideDirectionChanged: turnSideDirectionChanged
//                ,
//                yawRotationRateMovingAverage: yawRotationRateMovingAverage,
//                fallLineOrthogonalAcceleration: fallLineOrthogonal.targetDirectionAcceleration,
//                fallLineOrthogonalRelativeAttitude: fallLineOrthogonal.relativeAttitude)

        
    }
}



