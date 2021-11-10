//
//  MovingPhasesProtocol.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion
protocol MovingPhasesProtocol{
    var movingPhases: [MovingPhaseProtocol]{get}
    // yaw の最大
//    func maxRollAttitudePhase()->MovingPhaseProtocol
// ターンしているか判定する
//  ターンってなに？　どのぐらいの小さな波をターンとして設定するの？
// 大きさを角度で決める　何度回転したら　どれぐらいの加速度　速度があったら　いいのか？
    func isTurnMax() throws -> Bool
}

protocol MovingPhaseProtocol {
    var attitude: Attitude{get}
    var userAcceleration: CMAcceleration {get}
    var timeStampSince1970: TimeInterval{get}
    var rotationRate: CMRotationRate{get}
}