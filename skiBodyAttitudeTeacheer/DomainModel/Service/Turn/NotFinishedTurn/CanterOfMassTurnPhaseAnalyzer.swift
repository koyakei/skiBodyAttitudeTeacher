//
// Created by koyanagi on 2021/11/16.
//

import Foundation

protocol TurnPhaseAnalyzerProtocol {
    var movingPhases: [MovingPhaseProtocol] { get }
    var turnPhaseFinder: TurnChronologicalPhaseFinder { get }
    var turnPeriodFinder: TurnSideChangingPeriodFinder { get }
}

struct CanterOfMassTurnPhaseAnalyzer: TurnPhaseAnalyzerProtocol {
    var movingPhases: [MovingPhaseProtocol] = []
    // true right to left false left to right
    // minus is right turn
    // plus left turn
    var turnSideFinder = YawRotationRateMovingAverageFinder.init()
    var turnPhaseFinder: TurnChronologicalPhaseFinder = TurnChronologicalPhaseFinder.init()
    var turnPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()

//    mutating func handle
//            (movingPhase: MovingPhase) ->
//            CenterOfMassTurnPhase {
//        let turnSide = turnSideFinder.handle(absoluteRotationRate: movingPhase.absoluteRotationRate, timeStampSince1970: movingPhase.timeStampSince1970)
//        // フォールライン方向の加速度を計算
//        // 他の指標も計算していく
//        // ピボットスリップを計算する前提で考えてみよう
//        // 前回のターン切り替えからの偏角は計算するか？　べつにしなくていいか
//        // フォールラインと直角方向の加速度を計算
//        let fallLineOrthogonal:
//                TargetDirectionAccelerationAndRelativeAttitude
//                =
//                FallLineOrthogonalAccelerationCalculator.handle(turnSideDirection: turnPhaseFinder.rightTurnFromSwitchTurnSideToEnd, fallLineYawAngle: yawRotationRateMovingAverage, userAcceleration: movingPhase.userAcceleration, userAttitude: movingPhase.attitude)
//        // それを oneTurn にいれる とりあえず 5000 コマ超えたら csv に入れればいい
//        // これはやらなくていいターンが終わったらそれらをTurnPhases ぶちこむ
//        CenterOfMassTurnPhase.init(
//                movingPhaseProtocol: movingPhase, movingAverageYawAngle: yawingSimpleMovingAverage, turnFinished: turnFinished, turnSideDirectionChanged: turnSideDirectionChanged,
//                isTurnMax: isTurnMax,
//                yawRotationRateMovingAverage: yawRotationRateMovingAverage, rotationRateDirectionChangePeriod: rotationRateDirectionChangePeriod)
//
//        //        if turnFinished {
//        //            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
//        //            turnPhaseFromInitiation()
//        //        }
//    }
}

