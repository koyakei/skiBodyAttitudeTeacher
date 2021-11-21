//
// Created by koyanagi on 2021/11/18.
//

import Foundation

struct TurnSideChangingPeriodFinder {
    var lastSwitchedTurnSideTimeStamp: TimeInterval = Date.now.timeIntervalSince1970
    // TODO:デフォルト設定共通化
    var lastPeriod: TimeInterval = 1
    var lastYawingSide: TurnYawingSide = TurnYawingSide.Straight

    mutating func handle
            (currentTimeStampSince1970: TimeInterval, currentYawingSide: TurnYawingSide) -> TimeInterval {
        if (lastYawingSide != currentYawingSide){
            lastPeriod = currentTimeStampSince1970 - lastSwitchedTurnSideTimeStamp
            lastSwitchedTurnSideTimeStamp = currentTimeStampSince1970
        }
        return lastPeriod
    }
}
