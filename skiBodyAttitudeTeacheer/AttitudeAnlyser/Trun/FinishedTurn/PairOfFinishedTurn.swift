//
//  PairOfFinishedTurn.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

struct PairOfFinishedTurn {
    let oldTurnPhases:OneFinisedSkiTurn
    let newTurnPhases:OneFinisedSkiTurn
    // 地面に近い方に回り込むように設定する必要がある。
    func rollBace() -> Double{
        (
            self.oldTurnPhases.turnMaxPhase().turnPhase.attitude.roll -
            newTurnPhases.turnMaxPhase().turnPhase.attitude.roll
        ) / 2
    }
    
    func absoluteFallLineAttitude()-> Attitude{
        return Attitude.init(roll: rollBace(),
                             yaw: newTurnPhases.turnMaxPhase().turnPhase.attitude.yaw,
                             pitch: newTurnPhases.turnMaxPhase().turnPhase.attitude.pitch)
    }
}
