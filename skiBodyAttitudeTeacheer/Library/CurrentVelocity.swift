//
// Created by koyanagi on 2021/11/16.
// TODO: 処理の共通化するべき

import Foundation

struct CurrentVelocity{
    var initalSpeed: Double
    mutating func handle(currentAcceleration : Double , currentiTimestamp :TimeInterval, beforeMovingPhaseTimeStamp: TimeInterval) -> Double{
        initalSpeed += ( currentiTimestamp - beforeMovingPhaseTimeStamp) * currentAcceleration * -1
        return initalSpeed
    }
}
