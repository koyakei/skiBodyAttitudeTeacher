//
// Created by koyanagi on 2021/11/20.
//

import Foundation
import CoreMotion
import simd

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
    
    // 最小　最大の差が　基準値以上あるかどうか？
    func minMaxDiffrence(val: Double) -> Bool {
        let min : Double = self.min(by: {(a,b) -> Bool in return a.absoluteRotationRate.z < b.absoluteRotationRate.z })?.absoluteRotationRate.z ?? 0
        let max: Double  = self.max(by: {(a,b) -> Bool in return a.absoluteRotationRate.z < b.absoluteRotationRate.z })?.absoluteRotationRate.z ?? 0
        return abs(max - min) > Measurement(value: 10, unit: UnitAngle.degrees).converted(to: .radians).value
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

protocol AbsoluteQuaternionProtocol: RecordWithTimeStamp {
    var quaternion: simd_quatd { get }
}

extension Collection where Element: AbsoluteQuaternionProtocol {
    func yawYawingMovingAverage(yawingPeriod: TimeInterval) -> simd_quatd {
        simd_normalize(self.filterByBeforeMilleSecondsFromNow(timeInterval: yawingPeriod).map {
            $0.quaternion}.reduce(simd_quatd(ix: 0,iy: 0,iz: 0,r: 0),+))
        
    }
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
