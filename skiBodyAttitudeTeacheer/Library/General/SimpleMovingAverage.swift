//
// Created by koyanagi on 2021/11/08.
//

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








