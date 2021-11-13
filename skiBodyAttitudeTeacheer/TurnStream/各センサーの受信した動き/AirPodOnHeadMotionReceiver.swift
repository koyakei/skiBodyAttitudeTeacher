//
//  AirPodOnHead.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
struct AirPodOnHeadMotionReceiver: MotionStreamReceiver{
    var movingPhases: [MovingPhase]
    
    
    mutating func receiver(movingPhase: MovingPhase) {
        movingPhases.append(movingPhase)
    }
}
