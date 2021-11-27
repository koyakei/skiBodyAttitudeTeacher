//
//  AirPodOnHead.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import CoreMotion

struct AirPodOnHeadMotionReceiver {

    let 磁北偏差: Double
    var canterOfMassTurnPhaseAnalyzer: CenterOfMassTurnPhaseAnalyzer = CenterOfMassTurnPhaseAnalyzer.init()
    var turnPhases: [CenterOfMassTurnPhase] = []
    mutating func receiver(_ motion: CMDeviceMotion, _ timeStamp: TimeInterval) -> CenterOfMassTurnPhase{
        let v = canterOfMassTurnPhaseAnalyzer
                                .handle(movingPhase:
                                        MovingPhase.init(motion, timeStamp, 磁北偏差))
        turnPhases.append(v)
        return v
    }


}
