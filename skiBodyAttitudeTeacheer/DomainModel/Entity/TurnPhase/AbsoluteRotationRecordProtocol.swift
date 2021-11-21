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
            $0.timeStampSince1970 > Date.now.timeIntervalSince1970 - yawingPeriod
        }
    }
}



extension Collection where Element : AbsoluteRotationRecordProtocol{
    func yawRotationRateMovingAverage() -> Double {
        precondition(self.count > 1)
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
        precondition(yawingPeriod > 0)
        precondition(self.count > 1)
        return AverageAngleFinder.handle(angles_rad:
                                         self.filterByBeforeMilleSecondsFromNow().mapper()
        )
    }

    func mapper() -> [Double] {
        self.map {
            $0.yawMapper()
        }
    }
}