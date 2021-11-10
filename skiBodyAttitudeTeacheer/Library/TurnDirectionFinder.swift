//
// Created by koyanagi on 2021/11/06.
//

import Foundation

struct TurnDirectionFinder {

    static func handle(
            yawRotationRateSequence: [Double]
    ) -> Bool {
        (
                yawRotationRateSequence.reduce(0, +)
                        / Double(yawRotationRateSequence.count)).sign
                == .plus
    }

    static func handle(
            rollRotationRateSequence: [Double]
    ) -> Bool{

    }

    static func handle(
            pitchRotationRateSequence: [Double]
    ) -> Bool{

    }

    static func handle(
            rotationRateSequence: [Attitude]
    ) -> Bool{

    }
}
