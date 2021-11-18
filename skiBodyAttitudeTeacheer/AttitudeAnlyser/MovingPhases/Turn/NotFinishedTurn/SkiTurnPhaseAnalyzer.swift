//
//  TurnPhases.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

typealias TurnSide = Bool

struct TimeStampAndTurnSideDirectionChanged {
    let turnSideDirectionChanged: Bool
    let timeStampSince1970: Double
}

struct TimeStampAndTurnSideDirectionChangedPeriod {
    let turnSideDirectionChangedPeriod: Double
    let timeStampSince1970: Double
}


struct SkiTurnPhaseAnalyzer: MovingPhasesProtocol {
    var movingPhases: [MovingPhaseProtocol] = []
    // true right to left false left to right
    // plus is right turn
    // minus is left turn
    var turnPhaseFinder: TurnPhaseFinder = TurnPhaseFinder.init()
    var turnPeriodFinder: TurnPeriodFinder =
            TurnPeriodFinder.init()
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
        return (yawingSimpleMovingAverage, turnSideDirectionChanged, rotationRateDirectionChangePeriod)
        // turn finished じゃなくてターン開始からの１００分率で表記しようか？ ターン終了からの
    }

    mutating func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {
        movingPhases.append(movingPhase)
        // 角速度の平均を出す
        let yawRotationRateMovingAverage = movingPhases
                .yawRotationRateMovingAverage()
        let
        (yawingSimpleMovingAverage, turnSideDirectionChanged, rotationRateDirectionChangePeriod)
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
        if turnFinished {
            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
            MotionAnalyzerManager.shared.unify()
        }
        SkiTurnPhase.init(
                movingPhaseProtocol: movingPhase,
                movingAverageYawAngle: yawingSimpleMovingAverage,
                turnFinished: turnFinished,
                turnSideDirectionChanged: turnSideDirectionChanged,
                turnPhaseRatio: <#T##Float##Float#>,
                isTurnMax: isTurnMax,
                yawRotationRateMovingAverage: yawRotationRateMovingAverage,
                fallLineOrthogonalAcceleration: fallLineOrthogonal.targetDirectionAcceleration,
                fallLineOrthogonalRelativeAttitude: fallLineOrthogonal.relativeAttitude)


    }
}



