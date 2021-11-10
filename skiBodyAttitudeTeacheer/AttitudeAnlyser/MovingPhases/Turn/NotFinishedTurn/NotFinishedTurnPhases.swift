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

    mutating func turnMaxFromMovingPhase(movingPhase: MovingPhase) {
        let turnSideDirectionChanged: Bool =
                timeStampAndRotationRateXDirectionSideCollection[timeStampAndRotationRateXDirectionSideCollection.count - 2].turnSideDirection !=
                        timeStampAndRotationRateXDirectionSideCollection.last?.turnSideDirection
        timeStampAndTurnSideDirectionChanged.append(
                TimeStampAndTurnSideDirectionChanged.init(
                        turnSideDirectionChanged: turnSideDirectionChanged,
                        timeStampSince1970: timeStampAndRotationRateXDirectionSideCollection.last!.timeStampSince1970)
        )
        timeStampAndTurnSideDirectionChangedPeriod.append(
                TimeStampAndTurnSideDirectionChangedPeriod.init(
                        turnSideDirectionChangedPeriod: timeStampAndTurnSideDirectionChanged.yawPeriod(),
                        timeStampSince1970: timeStampAndTurnSideDirectionChangedPeriod.last!.timeStampSince1970)
        )
        let average: Double = movingPhases.yawAttitudeMovingAverage(
                milliSeconds: timeStampAndTurnSideDirectionChangedPeriod.last!.turnSideDirectionChangedPeriod)
        let turnFinished: Bool = isTurnMax(movingPhase: movingPhase)
        // turn finished じゃなくてターン開始からの１００分率で表記しようか？ ターン終了からの
        turnPhasesWithYawMovingAverage.append(
                TurnPhaseYawSimpleRotationRateAverage.init(
                        movingPhaseProtocol: movingPhase,
                        movingAverageYawAngle: average,
                        turnFinished: turnFinished,
                        turnSideDirectionChanged: turnSideDirectionChanged
                ))
        if turnFinished {
            // ターンが終わったら、ターンフェイズのどこにいるかを 100分率で計算
            turnPhaseFromInitiation()
        }
    }
    func movingPhaseReceiver(movingPhase: MovingPhase){
        // 角速度の平均を出す
        // 角速度の入れ替わりからターンの切り替え時を判定
        // ヨーイング角の平均角度計算
        // ターンマックスの判定
        // フォールライン方向の判定　前回のターンマックスヨーイング角をフォールラインとする。
        // フォールライン方向の加速度を計算
        // 他の指標も計算していく
        // ピボットスリップを計算する前提で考えてみよう
        // それを oneTurn にいれる とりあえず 5000 コマ超えたら csv に入れればいい
        // これはやらなくていいターンが終わったらそれらをTurnPhases ぶちこむ
    }

    // ローリング角の同調
    // ヨーイング角度の同調
    // 角速度の同調
    // ターンマックスが 180度以上離れていること
    // 各種スコアは毎ターンごとに出すのが良さそうだ。
    // ターン中盤でスコアを出したい場合は、区切りをもっと細かくしなきゃだめだね。
    // 途中でスコアを出さないとね。
    func pivotSlipScore(){

    }

    // ターン後半でのフォールライン方向の加速度の体とスキーの差で表現可能か？
    //
    func outSideTurnScore(){

    }

    // 前後バランススコア
    func forwardAfterwardBalanceScore(){

    }

    func スキーを通してフォールラインと逆方向に重心を運ぶ量(){
        
    }

    var oneTurn: [TurnPhase]

    func turnFinishFromMovingPhase(movingPhase: MovingPhase) {

    }

    func turnPhaseFromInitiation() -> Double {

    }

    var turnPhasesWithYawMovingAverage: [TurnPhaseYawSimpleRotationRateAverage]
    var xDirectionWithTimeStampCollection: [XRotationRateDirection]

    var turnPhaseWithRotationRateXDirection: [TurnPhaseWithRotationRateXDirection]
    var turnPhaseWithRotationRateXDirectionChangePeriod: [TurnPhaseWithRotationRateXDirectionChangePeriod]
    var turnPhasesWithYawRotationRate: [TurnPhaseProtocol]
    var movingPhases: [MovingPhaseProtocol]
    // 動いているか加速度の合計や角速度の大きさで測る
    // 2秒ぐらい  前後方向のみの速度変化にするか。　リフトだと完全な等速度になるのかなぁ。
    // decent じゃなくても検知するし。
    //同速度で運動していたら、加速度がない。　でも速度変化があることは期待しよう。
    func isMoving(continuedSeconds: Double = 2, minimumMPS: Double = 2) -> Bool {
        let towSeconds: [MovingPhaseProtocol] = movingPhases.filter {
            $0.timeStampSince1970 >
                    Calendar.current.date(
                            byAdding: .second,
                            value: Int(continuedSeconds), to: Date())!.timeIntervalSince1970
        }
        var afterSeconds: TimeInterval
        let al: [UATI] = towSeconds.reversed().map {
            var elapsed: TimeInterval
            if afterSeconds != nil {
                elapsed = afterSeconds - $0.timeStampSince1970
            }
            afterSeconds = $0.timeStampSince1970
            return UATI.init(accel:
            $0.userAcceleration.x,
                    ti: elapsed)
        }
        return al[1...(al.count - 1)].map {
            abs(PhysicsConstants.accelerationToVelocity(
                    accelerationByG: $0.accel, elapsedTime: $0.ti!
            ))
        }.reduce(0, +) / Double(continuedSeconds) > minimumMPS
    }

    struct UATI {
        let accel: Double
        let ti: TimeInterval?
    }

    // pitch が最大よりも小さければ、フォールラインよりも切り上がっていると判定する
    func turnMaxPassedByPitchAttitude() throws -> Bool {
        if (movingPhases.count > 10) {
            throw TurnError.tooShortToDetectMaxYawAttitude
        }
    }

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

}



