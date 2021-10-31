//
//  TurnPhase.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/29.
//

import Foundation
import CoreMotion

struct EvaluatedTrunPhase{
    let attitude: Attitude
    let userAccelaration: CMAcceleration
    let timeStampSInce1970: TimeInterval
    struct Attitude{
        let roll : Double
        let yaw: Double
        let pitch: Double
    }
    
    let bodyFallLineAccelaration: Double
    let skiFallLineAccelaration: Double
}

struct FallLineAttitude{
    let yaw: Double
    let pitch: Double
    let roll: Double
}

