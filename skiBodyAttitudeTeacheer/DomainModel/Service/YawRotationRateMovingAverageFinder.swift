//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

struct YawRotationRateMovingAverageFinder {
    struct AbsoluteRotationRecord: AbsoluteRotationRecordProtocol {
        let absoluteRotationRate: CMRotationRate
        let timeStampSince1970: TimeInterval
    }

    var rotationHistory: [AbsoluteRotationRecord] = []

    mutating func handle(absoluteRotationRate: CMRotationRate, timeStampSince1970: TimeInterval) -> CMRotationRate{
        rotationHistory.append(AbsoluteRotationRecord.init(absoluteRotationRate: absoluteRotationRate, timeStampSince1970: timeStampSince1970))
        return CMRotationRate.init(x: 0, y: 0, z: rotationHistory.yawRotationRateMovingAverage())
    }
}
