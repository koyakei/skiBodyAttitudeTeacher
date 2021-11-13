//
//  TurnPhases.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

typealias TurnSide = Bool

struct XRotationRateDirection {
    let rotationX: Double
    let timeStampSince1970: Double
}

struct TimeStampAndRotationRateXDirectionSide {
    // 右ターン  true left false
    let turnSideDirection: Bool
    let timeStampSince1970: Double
}

struct TimeStampAndTurnSideDirectionChanged {
    let turnSideDirectionChanged: Bool
    let timeStampSince1970: Double
}

struct TimeStampAndTurnSideDirectionChangedPeriod {
    let turnSideDirectionChangedPeriod: Double
    let timeStampSince1970: Double
}

struct TimeStampAndYawRotationRateMovingAverage {
    let yawRotationRateMovingAverage: Double
    let timeStampSince1970: Double
}


struct OneNotFinishedTurn: MovingPhasesProtocol {

    var timeStampAndYawRotationRateMovingAverageCollection: [TimeStampAndYawRotationRateMovingAverage]
    // true right to left false left to right
    // plus is right turn
    // minus is left turn
    var lastYawRotationRateDirection: Bool = true
    var lastYawAttitudeCrossZeroDirection: Bool = true

    mutating func isYawRotationRateDirectionChanged(movingPhase: MovingPhase) -> Bool {
        if lastYawRotationRateDirection {
            let res =
                    timeStampAndYawRotationRateMovingAverageCollection.last!.yawRotationRateMovingAverage < 0
                            && lastYawAttitudeCrossZeroDirection
            if res {
                lastYawRotationRateDirection = false
            }
            return res
        } else {
            let res = 0 < timeStampAndYawRotationRateMovingAverageCollection.last!.yawRotationRateMovingAverage
                    && lastYawAttitudeCrossZeroDirection == false
            if res {
                lastYawRotationRateDirection = true
            }
            return res
        }
    }

    mutating func isTurnFinished(movingPhase: MovingPhase) -> Bool {
        isYawRotationRateDirectionChanged(movingPhase: movingPhase)
    }


    mutating func isTurnMax(movingPhase: MovingPhase) -> Bool {
        if lastYawAttitudeCrossZeroDirection {
            let res = movingPhase.attitude.yaw <
                    turnPhasesWithYawMovingAverage.last!.movingAverageYawAngle
                    && lastYawRotationRateDirection
            if res {
                lastYawAttitudeCrossZeroDirection = false
            }
            return res
        } else {
            let res =
                    turnPhasesWithYawMovingAverage.last!.movingAverageYawAngle < movingPhase.attitude.yaw
                            && lastYawRotationRateDirection == false
            if res {
                lastYawAttitudeCrossZeroDirection = true
            }
            return res
        }
    }

    var timeStampAndRotationRateXDirectionSideCollection: [TimeStampAndRotationRateXDirectionSide]
    var timeStampAndTurnSideDirectionChanged: [TimeStampAndTurnSideDirectionChanged]
    var timeStampAndTurnSideDirectionChangedPeriod: [TimeStampAndTurnSideDirectionChangedPeriod]
    var fallLineYawAttitude: Double = 0

    mutating func turnMaxFromMovingPhase(movingPhase: MovingPhase) -> (Double, Bool, Bool, Bool, Double, Double) {
        let yawRotationRateMovingAverage = movingPhases.yawRotationRateMovingAverage()
        timeStampAndRotationRateXDirectionSideCollection.append(TimeStampAndRotationRateXDirectionSide.init(
                turnSideDirection: yawRotationRateMovingAverage.sign == .plus, // 右回り true
                timeStampSince1970: movingPhase.timeStampSince1970))
        // 角速度の入れ替わりからターンの切り替え時を判定
        let turnSideDirectionChanged: Bool =
                timeStampAndRotationRateXDirectionSideCollection[timeStampAndRotationRateXDirectionSideCollection.count - 2].turnSideDirection !=
                        timeStampAndRotationRateXDirectionSideCollection.last?.turnSideDirection
        timeStampAndTurnSideDirectionChanged.append(
                TimeStampAndTurnSideDirectionChanged.init(
                        turnSideDirectionChanged: turnSideDirectionChanged,
                        timeStampSince1970: timeStampAndRotationRateXDirectionSideCollection.last!.timeStampSince1970)
        )
        // ターンの周期を計算
        let rotationRateDirectionChangePeriod: Double = timeStampAndTurnSideDirectionChanged.yawRotationRateDirectionChangePeriod()
        timeStampAndTurnSideDirectionChangedPeriod.append(
                TimeStampAndTurnSideDirectionChangedPeriod.init(
                        turnSideDirectionChangedPeriod: rotationRateDirectionChangePeriod,
                        timeStampSince1970: timeStampAndTurnSideDirectionChangedPeriod.last!.timeStampSince1970)
        )
        // ターンの周期を移動平均したヨーイング角の平均角度を計算
        let yawingSimpleMovingAverage: Double = movingPhases.yawAttitudeMovingAverage(
                milliSeconds: rotationRateDirectionChangePeriod
        )
        let turnFinished: Bool = isTurnFinished(movingPhase: movingPhase)
        // ヨーイング角度を超えたらターンマックスとする
        let isTurnMax: Bool = isTurnMax(movingPhase: movingPhase)

        // フォールライン方向の判定　前回のターンマックスヨーイング角をフォールラインとする。
        if isTurnMax {
            fallLineYawAttitude = movingPhase.attitude.yaw
        }

        return (yawingSimpleMovingAverage,
                turnFinished, isTurnMax, turnSideDirectionChanged, rotationRateDirectionChangePeriod, yawRotationRateMovingAverage)
        // turn finished じゃなくてターン開始からの１００分率で表記しようか？ ターン終了からの
    }

    mutating func movingPhaseReceiver(movingPhase: MovingPhase) {
        movingPhases.append(movingPhase)
        // 角速度の平均を出す
        let (yawingSimpleMovingAverage, turnFinished,
             isTurnMax, turnSideDirectionChanged, rotationRateChangePeriod,
             yawRotationRateMovingAverage) = turnMaxFromMovingPhase(movingPhase: movingPhase)
        // フォールライン方向の加速度を計算
        // 他の指標も計算していく
        // ピボットスリップを計算する前提で考えてみよう
        // 前回のターン切り替えからの偏角は計算するか？　べつにしなくていいか
        // フォールラインと直角方向の加速度を計算
        let fallLineOrthogonal: TargetDirectionAccelerationAndRelativeAttitude = fallLineOrthogonalAcceleration(movingPhase: movingPhase)
        // それを oneTurn にいれる とりあえず 5000 コマ超えたら csv に入れればいい
        // これはやらなくていいターンが終わったらそれらをTurnPhases ぶちこむ
        turnPhasesWithYawMovingAverage.append(
                TurnPhase.init(
                        movingPhaseProtocol: movingPhase,
                        movingAverageYawAngle: yawingSimpleMovingAverage,
                        turnFinished: turnFinished,
                        turnSideDirectionChanged: turnSideDirectionChanged,
                        turnPhaseRatio: <#T##Float##Float#>,
                        isTurnMax: isTurnMax,
                        yawRotationRateMovingAverage: yawRotationRateMovingAverage,
                        fallLineOrthogonalAcceleration: fallLineOrthogonal.targetDirectionAcceleration,
                        fallLineOrthogonalRelativeAttitude: fallLineOrthogonal.relativeAttitude))

//        if turnFinished {
//            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
//            turnPhaseFromInitiation()
//        }
    }

    func fallLineDirection() -> Double {
        if timeStampAndRotationRateXDirectionSideCollection.last!.turnSideDirection {
            //右ターンのとき
            AngleShifter.handle(currentAngle: fallLineYawAttitude, shiftAngle: (Double.pi / 2 * -1))
        } else {
            // 左ターンのとき
            AngleShifter.handle(currentAngle: fallLineYawAttitude, shiftAngle: Double.pi / 2)// 右９０度
        }
    }

    func fallLineOrthogonalAcceleration(movingPhase: MovingPhase) ->
            TargetDirectionAccelerationAndRelativeAttitude {
        // 一番最新のフォールラインをGet それと直交するヨーイング方向を計算
        // その方向の加速度を習得
        AccelerationForTargetAngle.handle(
                userAcceleration: movingPhase.userAcceleration,
                userAttitude: movingPhase.attitude,
                targetAttitude: Attitude.init(roll: 0, yaw: fallLineDirection(), pitch: 0)
        )

    }


    // 常にフォールライン方向に体を運ぶスピードは最大にしなきゃいけない
    // フォールラインと直角に外側に向かって板と自分の距離が縮まる
    // ロール角が一定以上担った場合に、エッジグリップが高くなるのでそこから
    // スキーと自分の重心を話しながら、次のターン外側へ体を運ぶ
    // ロール角以外で縮めていいタイミングを決定できる要素はないのか？
    // ロール角が小さい以外で判断する材料がほしい
    // ヨーイング角ができるだけ深い内に小さくなって踏み始めたい。
    // できるだけ横方向の減速を遅らせたい。
    // 板がターンマックスで帰ってこない場合はどうなんだ？
    // 板が反ってくるかどうかって判定できるの？
    // スキーと重心の相対加速度がマイナスの場合。
    func スキーを通してフォールラインと直角に重心を運ぶ量() {

    }

    var oneTurn: [TurnPhase]

    func turnFinishFromMovingPhase(movingPhase: MovingPhase) {

    }

    func turnPhaseFromInitiation() -> Double {

    }

    var turnPhasesWithYawMovingAverage: [TurnPhase]
    var xDirectionWithTimeStampCollection: [XRotationRateDirection]

    var turnPhaseWithRotationRateXDirection: [TurnPhaseWithRotationRateXDirection]
    var turnPhaseWithRotationRateXDirectionChangePeriod: [TurnPhaseWithRotationRateXDirectionChangePeriod]
    var turnPhasesWithYawRotationRate: [TurnPhaseProtocol]
    var movingPhases: [MovingPhaseProtocol]


    // 比較している最中にrotation rate の符号が反転しないことを前提にする
    // そもそも ios自体が一秒間に180度を超える回転に対応していないのだろう。
    func rotationDirectionChanged(
            evaluationFrame: Int = 10,
            ターンと認める偏角秒: Double = 30) -> Bool {
        // 最後１０個 のヨーイング方向の角速度の平均
        let radian: Double = (Double.pi / 180) * ターンと認める偏角秒
        (movingPhases[
                (movingPhases.count - evaluationFrame)..<(movingPhases.count - 1)
                ].map {
            $0.rotationRate.z
        }.reduce(0, +) / Double(evaluationFrame)) > radian
    }

    func turnSideChangingPhase() -> MovingPhaseProtocol {
    }


    // 角速度の符号の入れ替わり周期
    func yawRotationRateSignChangePeriod() -> TimeInterval {
        let currentRotationDirection: Bool =
                ((movingPhases.last?.rotationRate.x.sign) != nil)
        currentRotationDirection
        // a = 最後に今とターン方向が違う局面を検出する
        // b = そこから過去にさかのぼって、符号が反転する局面を検出する
        // a - b = 周期として設定
    }

    // pitch が最大よりも小さければ、フォールラインよりも切り上がっていると判定する
    func turnMaxPassedByPitchAttitude() throws -> Bool {
        if (movingPhases.count > 10) {
            throw TurnError.tooShortToDetectMaxYawAttitude
        }
    }

}



