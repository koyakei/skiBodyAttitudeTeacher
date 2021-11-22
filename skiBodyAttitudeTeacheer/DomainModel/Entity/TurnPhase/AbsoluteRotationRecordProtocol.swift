//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion

protocol AbsoluteRotationRecordProtocol: RecordWithTimeStamp {
    var absoluteRotationRate: CMRotationRate { get }
}
extension AbsoluteRotationRecordProtocol {
    func mapper() -> Double {
        absoluteRotationRate.z
    }
}

protocol RecordWithTimeStamp {
    var timeStampSince1970: TimeInterval { get }
}

extension Collection where Element :RecordWithTimeStamp{
    func filterByBeforeMilleSecondsFromNow(
            yawingPeriod: TimeInterval) ->[Element]{
        self.filter{
            Date(timeIntervalSince1970: $0.timeStampSince1970) > Calendar.current.date(byAdding: .second, value: -1, to: Date(timeIntervalSince1970: $0.timeStampSince1970))!
        }
    }
}



extension Collection where Element : AbsoluteRotationRecordProtocol{
    func yawRotationRateMovingAverage() -> Double {
        return AverageAngleFinder.handle(angles_rad:
                                         self.filterByBeforeMilleSecondsFromNow(yawingPeriod: 0.1).mapper()
        )
    }

    func mapper() -> [Double] {
        self.map {
            $0.mapper()
        }
    }
}

protocol AbsoluteAttitudeProtocol : RecordWithTimeStamp{
    var attitude: Attitude { get }
}

extension AbsoluteAttitudeProtocol {
    func yawMapper() -> Double {
        attitude.yaw
    }
}

extension Collection where Element : AbsoluteAttitudeProtocol{
    func yawYawingMovingAverage(yawingPeriod: TimeInterval) -> Double {
        return AverageAngleFinder.handle(angles_rad:
                                            self.filterByBeforeMilleSecondsFromNow(yawingPeriod: yawingPeriod).mapper()
        )
    }

    func mapper() -> [Double] {
        self.map {
            $0.yawMapper()
        }
    }
}
