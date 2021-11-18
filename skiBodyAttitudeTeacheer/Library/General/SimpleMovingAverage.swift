//
// Created by koyanagi on 2021/11/08.
//　TODO: 正しい位置にファイルを置く

import Foundation

extension Collection where Element == Int, Index == Int {
    /// Calculates a moving average.
    /// - Parameter period: the period to calculate averages for.
    /// - Warning: the supplied `period` must be larger than 1.
    /// - Warning: the supplied `period` should not exceed the collection's `count`.
    /// - Returns: a dictionary of indexes and averages.
    func movingAverage(period: Int) -> [Int: Float] {
        precondition(period > 1)
        precondition(count > period)
        let result = (0..<self.count).compactMap { index -> (Int, Float)? in
            if (0..<period).contains(index) {
                return nil
            }
            let range = index - period..<index
            let sum = self[range].reduce(0, +)
            let result = Float(sum) / Float(period)

            return (index, result)
        }
        return Dictionary(uniqueKeysWithValues: result)
    }
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

extension Collection where Element == TimeStampAndTurnSideDirectionChanged {
    func yawRotationRateDirectionChangePeriod() -> Double {
        let last2 = self.filter {
            $0.turnSideDirectionChanged == true
        }[self.count - 2...self.count - 1]
        return last2.last!.timeStampSince1970 - last2.first!.timeStampSince1970
    }
}

typealias MilliSecond = Double



