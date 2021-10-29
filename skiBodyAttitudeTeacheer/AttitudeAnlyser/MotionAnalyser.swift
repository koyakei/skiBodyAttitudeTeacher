//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import UIKit

class MotionAnalyser{
    
    //一度
    let deg = 180/Double.pi
    
    var savedTrunStream:[TrunPhase] = []
    var oneTrunStream:[TrunPhase] = []
    // stream で受けて1ターン蓄積したら、流す
    func turnCutter(turnStream: [TrunPhase])-> [TrunPhase]{
        if(turnStream.first?.attitude.roll == 0){
            return turnStream
        }
        return turnStream
    }
    
    // ターンエンドで切っている物が来たとして、 フォールラインを検出
    func fallLineAttitude(
        yawStream: [Double]
    ) -> FallLineAttitude{
        let attitude = oneTrunStream.max(by: {(lhs,rhs)-> Bool in return lhs.attitude.roll < rhs.attitude.roll})!.attitude
        return FallLineAttitude.init(yaw: attitude.yaw, pitch: attitude.pitch)
    }
    
    func relativeFallLineAttitude(
        absoluteFalllineAttitude: FallLineAttitude,
        currentAttitude: TrunPhase.Attitude
    )-> FallLineAttitude {
        FallLineAttitude.init(yaw: absoluteFalllineAttitude.yaw - currentAttitude.yaw, pitch: absoluteFalllineAttitude.pitch - currentAttitude.pitch)
    }
    
    // fall line の方向への加速度を計算
    func fallLineAccelaration(
        currentAcceleration: CMAcceleration,
        relativeFallLineAttitude: TrunPhase.Attitude
    )-> Double{
        let x = currentAcceleration.x * cos(        relativeFallLineAttitude.yaw) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.roll) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.pitch)
        let y = currentAcceleration.x * cos(        relativeFallLineAttitude.yaw) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.roll) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.pitch)
        let z = currentAcceleration.x * cos(        relativeFallLineAttitude.yaw) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.roll) +
        currentAcceleration.x * cos(        relativeFallLineAttitude.pitch)
        return x + y + z
    }
}
