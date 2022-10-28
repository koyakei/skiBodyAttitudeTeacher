//
//  TurnDiffrencialFinder.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2022/10/27.
//

import Foundation
import simd
struct TurnDiffrencialFinder{
    var beforeTurnSwitchedAngle: simd_quatd = simd_quatd()
    var beforebeforeTurnSwitchedAngle: simd_quatd = simd_quatd()
    var beforeTurnSwitchedUnixTime: TimeInterval = 0
    var beforebeforeTurnSwitchedUnixTime: TimeInterval = 0
    
    mutating func turnswitchedRecive(movingPhase: MovingPhase){
        beforebeforeTurnSwitchedUnixTime = beforeTurnSwitchedUnixTime
        beforeTurnSwitchedUnixTime = movingPhase.timeStampSince1970
        beforebeforeTurnSwitchedAngle = beforeTurnSwitchedAngle
        beforeTurnSwitchedAngle = movingPhase.quaternion
    }
    
    func currentIdealDiffrencial(currentAngle: simd_quatd, currentTime: TimeInterval) -> Double{
        
        (
            Double( beforeTurnYawingDiffrencial())
         /
        beforeTurnDiffrencialTime()
         *
        abs(currentTime - beforeTurnSwitchedUnixTime)
        )
        -
        Double(currentYawingDiffrencial(currentAngle: currentAngle))
        
    }
    
    func beforeTurnDiffrencialTime() -> TimeInterval {
        beforeTurnSwitchedUnixTime - beforebeforeTurnSwitchedUnixTime
    }
    
    func currentYawingDiffrencial(currentAngle: simd_quatd) -> Float{
        abs(QuaternionToEullerAngleDifferential.handle(base: simd_quatf(currentAngle)
                                                    , target:
                                                    simd_quatf( beforeTurnSwitchedAngle)
        ).z)
    }
    
    func beforeTurnYawingDiffrencial() -> Float{
        abs(QuaternionToEullerAngleDifferential.handle(base:
                                                    simd_quatf( beforeTurnSwitchedAngle)
                                                    , target:
                                                    simd_quatf( beforebeforeTurnSwitchedAngle)
        ).z)
    }
}
