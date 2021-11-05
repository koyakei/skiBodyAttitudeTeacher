//
//  OneFinisedMonoSkiTurn.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
// ターン
struct OneFinisedMonoSkiTurn{
    let turnPhases: [SkiTurnPhaseWithFallLineAttitude]
    func turnSide()-> TurnSide{
        
    }
    func turnMaxPhase() -> SkiTurnPhaseWithFallLineAttitude{
        (self.turnPhases.max(by: { (a, b) -> Bool in
            return a.turnPhase.attitude.roll < b.turnPhase.attitude.roll
        }))!
    }
}
