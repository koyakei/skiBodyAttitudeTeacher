//
//  MovingPhasesProtocol.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

protocol MovingPhaseProtocol: AbsoluteRotationRecordProtocol, AbsoluteAttitudeProtocol {
    var userAcceleration: CMAcceleration { get }
    var rotationRate: CMRotationRate { get }
}

extension Collection where Element == MovingPhaseProtocol {

    func recentNSecondsFilter(seconds: Int) -> [Element] {
        self.filter {
            $0.timeStampSince1970 >
                    Calendar.current.date(
                            byAdding: .second,
                            value: Int(seconds), to: Date())!.timeIntervalSince1970
        }
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
