//
// Created by koyanagi on 2021/11/18.
//

import Foundation



struct TurnPeriodFinder {
    var timeStampAndTurnSideDirectionSide:
            [TimeStampAndTurnSideDirectionSide]
            = []
    var timeStampAndTurnSideDirectionChanged: [TimeStampAndTurnSideDirectionChanged]
            = []

    mutating func handle
            (currentTimeStampSince1970: TimeInterval,
             yawRotationRateMovingAverage:
                     Double) ->
            (Bool, Double) {
        timeStampAndTurnSideDirectionSide.append(TimeStampAndTurnSideDirectionSide.init(
                turnSideDirection: yawRotationRateMovingAverage.sign == .plus, // 上から見て　左回り true
                timeStampSince1970: currentTimeStampSince1970))
        // 角速度の入れ替わりからターンの切り替え時を判定
        let turnSideDirectionChanged: Bool
                = timeStampAndTurnSideDirectionSide[timeStampAndTurnSideDirectionSide.count - 2].turnSideDirection != timeStampAndTurnSideDirectionSide.last?.turnSideDirection
        timeStampAndTurnSideDirectionChanged.append(TimeStampAndTurnSideDirectionChanged.init(turnSideDirectionChanged: turnSideDirectionChanged, timeStampSince1970: timeStampAndTurnSideDirectionSide.last!.timeStampSince1970))
        // ターンの周期を計算

        // ターンの周期を移動平均したヨーイング角の平均角度を計算
        return
                (
                        turnSideDirectionChanged,
                        timeStampAndTurnSideDirectionChanged.yawRotationRateDirectionChangePeriod()
                )
    }
}
