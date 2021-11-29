//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

protocol RotationRateRecordProtocol: RecordWithTimeStamp {
    var absoluteRotationRate: CMRotationRate { get }
}

extension RotationRateRecordProtocol {
    func mapper() -> Double {
        absoluteRotationRate.z
    }
}

protocol RecordWithTimeStamp {
    var timeStampSince1970: TimeInterval { get }
}

extension Collection where Element: RecordWithTimeStamp {
    func filterByBeforeMilleSecondsFromNow(
            timeInterval: TimeInterval) -> [Element] {
        self.filter {
            $0.timeStampSince1970 > ($0.timeStampSince1970 - timeInterval)
        }
    }
}


extension Collection where Element: RotationRateRecordProtocol {
    func yawRotationRateMovingAverage(timeInterval: TimeInterval) -> Double {
        return AverageAngleFinder.handle(angles_rad:
                                         self.filterByBeforeMilleSecondsFromNow(timeInterval: timeInterval).mapper()
        )
    }

    func mapper() -> [Double] {
        self.map {
            $0.mapper()
        }
    }
}

protocol AbsoluteAttitudeProtocol: RecordWithTimeStamp {
    var attitude: Attitude { get }
}

extension AbsoluteAttitudeProtocol {
    func yawMapper() -> Double {
        attitude.yaw
    }
}

extension Collection where Element: AbsoluteAttitudeProtocol {
    func yawYawingMovingAverage(yawingPeriod: TimeInterval) -> Double {
        return AverageAngleFinder.handle(angles_rad:
                                         self.filterByBeforeMilleSecondsFromNow(timeInterval: yawingPeriod).mapper()
        )
    }

    func mapper() -> [Double] {
        self.map {
            $0.yawMapper()
        }
    }
}
