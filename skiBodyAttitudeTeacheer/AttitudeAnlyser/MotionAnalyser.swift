//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import UIKit

struct TrunCorrector{
    var turnStream:[TrunPhase]
    let beforeOneTrun: OneFinisedTurn
    let beforeTrunMax: Double
    let afterTrunMax: Double
    
    func turnCutter(turnStream: [TrunPhase])-> OneFinisedTurn {
        
    }
    
}

struct MotionEvaluater{
    let pairOfFinishedTrun : PairOfFinishedTurn
    
    // ターン後半のワットでかんがえるか？
    func score() -> Int{
        return 100
    }
    // stream で受けて1ターン蓄積したら、流す
    
    
    func relativeFallLineAttitude(
        absoluteFalllineAttitude: FallLineAttitude,
        currentAttitude: TrunPhase.Attitude
    )-> FallLineAttitude {
        FallLineAttitude.init(yaw: absoluteFalllineAttitude.yaw - currentAttitude.yaw,
                              pitch: absoluteFalllineAttitude.pitch - currentAttitude.pitch,
                              roll: absoluteFalllineAttitude.roll - currentAttitude.roll)
    }
    
    // fall line の方向への加速度を計算
    func fallLineAccelaration(
        currentAcceleration: CMAcceleration,
        relativeFallLineAttitude: FallLineAttitude
    )-> Double{
        let x = currentAcceleration.x * cos(        relativeFallLineAttitude.yaw)   * cos(        relativeFallLineAttitude.pitch)
        let y = currentAcceleration.y * cos(        relativeFallLineAttitude.yaw)   * cos(        relativeFallLineAttitude.roll)
        let z = currentAcceleration.z * cos(        relativeFallLineAttitude.pitch)   * cos(        relativeFallLineAttitude.roll)
        return x + y + z
    }
    
}
