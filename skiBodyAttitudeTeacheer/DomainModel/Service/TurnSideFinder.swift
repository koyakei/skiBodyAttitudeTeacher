//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

struct TurnSideFinder {
    struct AbsoluteRotationRecord: AbsoluteRotationRecordProtocol {
        let absoluteRotationRate: CMRotationRate
        let timeStampSince1970: TimeInterval
    }

    var rotationHistory: [AbsoluteRotationRecord] = []

    mutating func handle(absoluteRotationRate: CMRotationRate, timeStampSince1970: TimeInterval) -> TurnYawingSide{
        rotationHistory.append(AbsoluteRotationRecord.init(absoluteRotationRate: absoluteRotationRate, timeStampSince1970: timeStampSince1970))
        rotationHistory.yawRotationRateMovingAverage()
    }
}
