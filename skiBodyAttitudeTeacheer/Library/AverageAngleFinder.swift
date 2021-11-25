//
// Created by koyanagi on 2021/11/05.
//　180 to - 180 の間で　角度の平均を算出

import Foundation

struct AverageAngleFinder {
    static func handle(angles_rad: [Double]) -> Double {
        let ang_avg: Double =
                atan2(angles_rad.map {
                    sin($0)
                }.reduce(0.0, +) / Double(angles_rad.count),
                        angles_rad.map {
                            cos($0)
                        }.reduce(0.0, +) / Double(angles_rad.count)) // なんで マイナス1?
        
        if (abs(ang_avg) > pow(10, -8)) {
            return ang_avg
        }
        return .zero
    }
}
