//
//  OneFinishedMonoSkiTurn.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation

struct OneFinishedMonoSkiTurn: FinishedTurnProtocol {

    func maxYawAttitudePhase() -> MovingPhaseProtocol {
        MaxAngleFinder.handle(movingPhases: movingPhases, baseDegree: (movingPhases.first?.attitude.yaw)!)
    }

    func turnFinished() -> Bool {
        TurnFinishedChecker.init(movingPhases: movingPhases).handle()
    }

    var movingPhases: [MovingPhaseProtocol]

    var turnStartPhase: MovingPhaseProtocol {
        get {
            movingPhases[0]
        }
    }

    var turnEndPhase: MovingPhaseProtocol {
        get {
            movingPhases[movingPhases.count - 1]
        }
    }
    // start < フォールライン < end == right turn
    // start > fall line > end == left turn
    func turnSide() -> TurnSide {
        // true + is turn right
        let startToFallLineTurnSide = TwoAngleDiffrencial.handle(
                angle: turnStartPhase.attitude.yaw,
                secondAngle: maxYawAttitudePhase().attitude.yaw
        )
        // true + is turn right
        let fallLineToEndTurnSide = TwoAngleDiffrencial.handle(
                angle: maxYawAttitudePhase().attitude.yaw,
                secondAngle: turnEndPhase.attitude.yaw
        )
        if isTurnMax() {
            if (startToFallLineTurnSide > 0
                    &&
                    fallLineToEndTurnSide > 0
               ) {
                return TurnSide(true)
            } else if (
                              startToFallLineTurnSide < 0
                                      &&
                                      fallLineToEndTurnSide < 0
                      ) {
                return TurnSide(false)
            }
        }
    }
}
