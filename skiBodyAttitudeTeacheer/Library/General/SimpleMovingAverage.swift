//
// Created by koyanagi on 2021/11/08.
//

import Foundation

class SimpleMovingAverage {
    var q: [Double] = [Double]()
    var size: Int = 0
    var sum: Double = 0

    init(_ size: Int) {
        self.size = size
        sum = 0
    }

    func next(_ val: Double) -> Double {
        if q.count >= size {
            let num: Double = Double(q.removeFirst())
            sum -= num
        }
        q.append(val)
        sum += Double(val)
        return sum / Double(q.count)
    }
}

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
    func convertLastPhaseToTurnPhaseWithRotationRateXDirection(
            milliSeconds: Double = 2000,
            beforeTurnSide: Bool
    ) -> TurnPhaseWithRotationRateXDirection {
        let avr: Double = self.filter {
            $0.timeStampSince1970 >
                    (Calendar.current.date(
                            byAdding: .nanosecond,
                            value: Int(milliSeconds * 1000)
                            , to: Date())!.timeIntervalSince1970 as Double)
        }.map {
            $0.rotationRate.z
        }.reduce(0, +) / Double(self.count)
        return TurnPhaseWithRotationRateXDirection.init(
                movingPhaseProtocol: self[self.endIndex]
                , movingAverageYawAngle: avr,
                rotationRateXDirection: TurnSide(avr.sign == .plus),
                turnSideChanged: TurnSide(avr.sign == .plus) != beforeTurnSide
        )
    }

    func yawRotationRateMovingAverage(milliSeconds: Double = 200) -> Double {
        precondition(self.count > 1)
        precondition(milliSeconds > 0)
        let res: Double = AverageAngleFinder.handle(angles_rad:
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
        return res
    }

    func yawAttitudeMovingAverage(milliSeconds: Double = 2000) -> Double {
        precondition(self.count > 1)
        precondition(milliSeconds > 0)
        let res: Double = AverageAngleFinder.handle(angles_rad:
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
        return res
    }

}

extension Collection where Element == TurnPhaseYawSimpleRotationRateAverage {
    // 振り返ってターンフェイズのどこにいるかを100分率でつけなくてもいいだろ
    // 今の時点がどれぐらいちがうのか　考えていくか

}

extension Collection where Element == TurnPhaseWithRotationRateXDirectionProtocol {
    func convertLastPhaseToTurnPhaseWithTurnPhaseWithRotationRateXDirectionChangePeriod(
            milliSeconds: Double = 2000) ->
            TurnPhaseWithRotationRateXDirectionChangePeriod {
        let avr: Double = self.filter {
            $0.timeStampSince1970 >
                    (Calendar.current.date(
                            byAdding: .nanosecond,
                            value: Int(milliSeconds * 1000)
                            , to: Date())!.timeIntervalSince1970 as Double)
        }.map {
            $0.rotationRate.z
        }.reduce(0, +) / Double(self.count)
    }
}

extension Collection where Element == TurnPhaseWithRotationRateXDirectionChangePeriodProtocol {
    func yawAttitudeMovingAverage(milliSeconds: Double = 2000) -> Double {
        precondition(self.count > 1)
        precondition(milliSeconds > 0)
        let res: Double = AverageAngleFinder.handle(angles_rad:
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
        return res
    }
}

extension Collection where Element == TimeStampAndTurnSideDirectionChanged {
    func yawPeriod() -> Double{
        let last2 = self.filter{
            $0.turnSideDirectionChanged == true
        }[self.count - 2...self.count - 1]
        return last2.last!.timeStampSince1970 - last2.first!.timeStampSince1970
    }
}

typealias MilliSecond = Double

extension Collection where Element == TimeStampAndRotationRateXDirectionSide {
    func rotationRateXDirectionChangePeriod(
            milliSeconds: Double = 2000) ->
            TimeStampAndTurnSideDirectionChanged {


    }
}