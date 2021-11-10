//
// Created by koyanagi on 2021/11/06.
//

import Foundation

struct MaxAngleFinder {
    // - pi to pi  far from fallLine
    static func handle(angles: [Double], baseDegree: Double) -> Double {
        // 最小最大　両方かえせばいいか。
        (angles.map{
            abs(TwoAngleDiffrencial.handle(angle: $0, secondAngle: baseDegree))
        }.max(by: { (a, b) -> Bool in
            a < b
        }))!
    }

    // 最大角
    static func handle(movingPhases:[MovingPhaseProtocol] , baseDegree: Double) -> MovingPhaseProtocol {
        let v : MovingPhase = movingPhases.max(by: { (a, b) -> Bool in
            abs(TwoAngleDiffrencial.handle(angle: baseDegree, secondAngle: a.attitude.yaw))
                    < abs(TwoAngleDiffrencial.handle(angle: baseDegree, secondAngle: b.attitude.yaw))
        }) as! MovingPhase
        return v
    }
}
