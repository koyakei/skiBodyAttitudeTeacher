//
// Created by koyanagi on 2021/11/18.
//

import Foundation

struct TurnSideChangingPeriodFinder {
    var lastSwitchedTurnSideTimeStamp: TimeInterval = Date.now.timeIntervalSince1970
    // TODO:デフォルト設定共通化
    var yawingSideRecords: [TurnYawingSide] = [TurnYawingSide.Straight]

    //　ストレート挟んでも
    // ストレート　右　ストレート　右　　右ターン
    //
    mutating func handle
            (currentTimeStampSince1970: TimeInterval, currentYawingSide: TurnYawingSide) -> TimeInterval {
        // 全部右ターンが続いていたら、
       if (yawingSideRecords.isLeftYawingContinued() && currentYawingSide == TurnYawingSide.RightYawing) ||
                                                               (yawingSideRecords.isRightYawingContinued() && currentYawingSide == TurnYawingSide.LeftYawing)                                                                                                                                      {
            // ターン方向が変わっていたら
            lastSwitchedTurnSideTimeStamp = currentTimeStampSince1970
            yawingSideRecords = [TurnYawingSide.Straight] // 初期化
        }
        yawingSideRecords.append(currentYawingSide)
        return currentTimeStampSince1970 - lastSwitchedTurnSideTimeStamp
    }
}
