//
//  PairOfFinishedTurn.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

struct PairOfFinishedTurn {
    let oldTurnPhases: FinishedTurnProtocol
    let newTurnPhases: FinishedTurnProtocol

    func rollBase() -> Double {
        AverageAngleFinder.handle(angles_rad: [
            oldTurnPhases.maxYawAttitudePhase().attitude.roll,
            newTurnPhases.maxYawAttitudePhase().attitude.roll
        ])
    }

    func absoluteFallLineAttitudeYaw() -> Double {
        oldTurnPhases.maxYawAttitudePhase().attitude.yaw
                - newTurnPhases.maxYawAttitudePhase().attitude.yaw
    }
}
