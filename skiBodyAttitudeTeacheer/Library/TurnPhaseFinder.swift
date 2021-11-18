//
// Created by koyanagi on 2021/11/18.
//

import Foundation

struct TurnPhaseFinder {
    var rightTurnFromSwitchTurnSideToEnd: Bool = true
    var rightToLeftTurnMax: Bool = true
    mutating func isYawRotationRateDirectionChanged(
            movingPhase: MovingPhase,
            yawRotationRateMovingAverage: Double
    )
                    -> Bool {
        if rightTurnFromSwitchTurnSideToEnd {
            let res = yawRotationRateMovingAverage
                      < 0 &&
                      rightToLeftTurnMax
            if res {
                rightTurnFromSwitchTurnSideToEnd = false
            }
            return res
        } else {
            let res = 0 < yawRotationRateMovingAverage &&
                      rightToLeftTurnMax == false
            if res {
                rightTurnFromSwitchTurnSideToEnd = true
            }
            return res
        }
    }

    mutating func isTurnFinished(movingPhase: MovingPhase,
                                 yawRotationRateMovingAverage: Double) -> Bool {
        isYawRotationRateDirectionChanged(movingPhase: movingPhase, yawRotationRateMovingAverage: yawRotationRateMovingAverage)
    }

    mutating func isTurnMax(movingPhase: MovingPhase,
                            yawRotationRateMovingAverage: Double) -> Bool {
        if rightToLeftTurnMax {
            let res = movingPhase.attitude.yaw < yawRotationRateMovingAverage && rightTurnFromSwitchTurnSideToEnd
            if res {
                rightToLeftTurnMax = false
            }
            return res
        } else {
            let res = yawRotationRateMovingAverage < movingPhase.attitude.yaw && rightTurnFromSwitchTurnSideToEnd == false
            if res {
                rightToLeftTurnMax = true
            }
            return res
        }
    }
}