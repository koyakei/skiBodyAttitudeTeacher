//
// Created by koyanagi on 2021/11/20.
//

import Foundation

struct AbsoluteFallLineAttitudeFinder {
    struct AbsoluteAttitudeRecord: AbsoluteAttitudeProtocol {
        let attitude: Attitude
        let timeStampSince1970: TimeInterval
    }

    var absoluteAttitudeRecords: [AbsoluteAttitudeRecord] = []

    mutating func handle(attitude: Attitude, timeStampSince1970: TimeInterval, yawingPeriod: TimeInterval) -> Attitude {
        absoluteAttitudeRecords.append(AbsoluteAttitudeRecord.init(attitude: attitude, timeStampSince1970: timeStampSince1970))
        Attitude.init(roll: 0,
                      yaw:
                      absoluteAttitudeRecords.yawYawingMovingAverage(yawingPeriod: yawingPeriod), pitch: 0)
    }
}