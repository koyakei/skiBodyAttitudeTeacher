//
//  AirPodOnHead.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
struct AirPodOnHeadMiotionReceiver: MotionStreamReceiver{
    var turnPhases: TurnPhases
    
    
    mutating func receiver(turnPhase: TurnPhase) {
        self.turnPhases.turnPhases.append(turnPhase)
    }
}
