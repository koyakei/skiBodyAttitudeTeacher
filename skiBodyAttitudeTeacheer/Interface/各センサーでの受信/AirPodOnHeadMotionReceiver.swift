//
//  AirPodOnHead.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import CoreMotion

struct AirPodOnHeadMotionReceiver {
    var turnPhases:
            [CenterOfMassTurnPhase]
            = []
    var notFinishedSkiTurnPhases: CanterOfMassTurnPhaseAnalyzer = CanterOfMassTurnPhaseAnalyzer.init()

    mutating func receiver(_ motion: CMDeviceMotion, _ timeStamp: TimeInterval) {
        turnPhases.append(
                notFinishedSkiTurnPhases
                                .handle(movingPhase:
                                        MovingPhase.init(motion, timeStamp)))
    }


}
