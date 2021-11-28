//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

struct YawRotationRateMovingAverageFinder {
    struct RotationRateRecord: RotationRateRecordProtocol {
        
        let absoluteRotationRate: CMRotationRate
        let timeStampSince1970: TimeInterval
    }

    var rotationHistory: [RotationRateRecord] = []

    mutating func handle(absoluteRotationRate: CMRotationRate, timeStampSince1970: TimeInterval, period: TimeInterval) -> CMRotationRate{
        if rotationHistory.count > 200{
            rotationHistory.removeFirst()
        }
        rotationHistory.append(RotationRateRecord.init(absoluteRotationRate: absoluteRotationRate, timeStampSince1970: timeStampSince1970))
        return CMRotationRate.init(x: 0, y: 0, z: rotationHistory.yawRotationRateMovingAverage(timeInterval: period))
    }
}
