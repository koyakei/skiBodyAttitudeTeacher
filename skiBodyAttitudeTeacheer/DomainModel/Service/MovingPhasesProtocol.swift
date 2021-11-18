//
//  MovingPhasesProtocol.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

protocol MovingPhaseProtocol {
    var attitude: Attitude { get }
    var userAcceleration: CMAcceleration { get }
    var timeStampSince1970: TimeInterval { get }
    var rotationRate: CMRotationRate { get }
    var absoluteRotationRate: CMRotationRate { get }
}

extension Collection where Element == MovingPhaseProtocol {

    func recentNSecondsFilter(seconds: Int) -> [MovingPhaseProtocol] {
        self.filter {
            $0.timeStampSince1970 >
                    Calendar.current.date(
                            byAdding: .second,
                            value: Int(seconds), to: Date())!.timeIntervalSince1970
        }
    }

    func yawRotationRateMovingAverage(milliSeconds: Double = 200) -> Double {
        precondition(self.count > 1)
        precondition(milliSeconds > 0)
        return AverageAngleFinder.handle(angles_rad:
                                         self.filter {
                                             $0.timeStampSince1970 >
                                                     (Calendar.current.date(
                                                             byAdding: .nanosecond,
                                                             value: Int(milliSeconds * 1000)
                                                             , to: Date())!.timeIntervalSince1970 as Double)
                                         }.map {
                                             $0.rotationRate.z
                                         }
        )
    }

    func yawAttitudeMovingAverage(milliSeconds: Double = 2000) -> Double {
        precondition(self.count > 1)
        precondition(milliSeconds > 0)
        return AverageAngleFinder.handle(angles_rad:
                                         self.filter {
                                             $0.timeStampSince1970 >
                                                     (Calendar.current.date(
                                                             byAdding: .nanosecond,
                                                             value: Int(milliSeconds * 1000)
                                                             , to: Date())!.timeIntervalSince1970 as Double)
                                         }.map {
                                             $0.attitude.yaw
                                         }
        )
    }

}
