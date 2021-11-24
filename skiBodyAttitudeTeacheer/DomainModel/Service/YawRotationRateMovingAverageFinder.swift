//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

struct YawRotationRateMovingAverageFinder {
    struct RotationRateRecord: RotationRateRecordProtocol {
        let rotationRate: CMRotationRate
        let timeStampSince1970: TimeInterval
    }

    var rotationHistory: [RotationRateRecord] = []

    mutating func handle(rotationRate: CMRotationRate, timeStampSince1970: TimeInterval) -> CMRotationRate{
        if rotationHistory.count > 200{
            rotationHistory.removeFirst()
        }
        rotationHistory.append(RotationRateRecord.init(rotationRate: rotationRate, timeStampSince1970: timeStampSince1970))
        return CMRotationRate.init(x: 0, y: 0, z: rotationHistory.yawRotationRateMovingAverage())
    }
}
