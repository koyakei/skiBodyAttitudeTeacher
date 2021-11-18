//
// Created by koyanagi on 2021/11/16.
//

import Foundation

struct CanterOfMassTurnPhaseAnalyzer: MovingPhasesProtocol {
    var movingPhases: [MovingPhaseProtocol] = []
    // true right to left false left to right
    // minus is right turn
    // plus left turn
    var turnPhaseFinder: TurnPhaseFinder = TurnPhaseFinder.init()
    var turnPeriodFinder: TurnPeriodFinder =
            TurnPeriodFinder.init()
    //    var lastTurnMaxYawAngle: Double
    //            = 0

    mutating func turnMaxFromMovingPhase
            (_ movingPhase: MovingPhase,
             _ yawRotationRateMovingAverage:
                     Double) -> (Double, Bool, Double) {

        // ここの処理の順番は変えられない
        let (turnSideDirectionChanged,
             rotationRateDirectionChangePeriod) =
                turnPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970,
                                        yawRotationRateMovingAverage: yawRotationRateMovingAverage)
        // ターンの周期を計算
        let yawingSimpleMovingAverage = movingPhases
                .yawAttitudeMovingAverage(milliSeconds: rotationRateDirectionChangePeriod)
        // ターンの周期を移動平均したヨーイング角の平均角度を計算

        // ヨーイング角度を超えたらターンマックスとする


        // フォールライン方向の判定　前回のターンマックスヨーイング角をフォールラインとする。
        //        if isTurnMax {
        //            lastTurnMaxYawAngle = turnPhasesAnalyzed.last!
        //                    .yawRotationRateMovingAverage
        //        }

        return (yawingSimpleMovingAverage, turnSideDirectionChanged, rotationRateDirectionChangePeriod)
        // turn finished じゃなくてターン開始からの１００分率で表記しようか？ ターン終了からの
    }

    mutating func handle
            (movingPhase: MovingPhase) ->
            CenterOfMassTurnPhase {
        movingPhases.append(movingPhase)
        // 角速度の平均を出す
        let yawRotationRateMovingAverage = movingPhases
                .yawRotationRateMovingAverage()
        let
        (yawingSimpleMovingAverage,turnSideDirectionChanged, rotationRateDirectionChangePeriod)
                = turnMaxFromMovingPhase(
                movingPhase, yawRotationRateMovingAverage)
        let isTurnMax: Bool = turnPhaseFinder
                .isTurnMax(movingPhase:
                           movingPhase, yawRotationRateMovingAverage: yawRotationRateMovingAverage)
        let turnFinished = turnPhaseFinder.isTurnFinished(
                movingPhase: movingPhase, yawRotationRateMovingAverage: yawRotationRateMovingAverage)
        // フォールライン方向の加速度を計算
        // 他の指標も計算していく
        // ピボットスリップを計算する前提で考えてみよう
        // 前回のターン切り替えからの偏角は計算するか？　べつにしなくていいか
        // フォールラインと直角方向の加速度を計算
        let fallLineOrthogonal:
                TargetDirectionAccelerationAndRelativeAttitude
                =
                FallLineOrthogonalAccelerationCalculator.handle(turnSideDirection: turnPhaseFinder.rightTurnFromSwitchTurnSideToEnd, fallLineYawAngle: yawRotationRateMovingAverage, userAcceleration: movingPhase.userAcceleration, userAttitude: movingPhase.attitude)
        // それを oneTurn にいれる とりあえず 5000 コマ超えたら csv に入れればいい
        // これはやらなくていいターンが終わったらそれらをTurnPhases ぶちこむ
        CenterOfMassTurnPhase.init(
                movingPhaseProtocol: movingPhase, movingAverageYawAngle: yawingSimpleMovingAverage, turnFinished: turnFinished, turnSideDirectionChanged: turnSideDirectionChanged,
                isTurnMax: isTurnMax,
                yawRotationRateMovingAverage: yawRotationRateMovingAverage, rotationRateDirectionChangePeriod: rotationRateDirectionChangePeriod)

        //        if turnFinished {
        //            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
        //            turnPhaseFromInitiation()
        //        }
    }
}

