//
// Created by koyanagi on 2021/11/16.
// TODO: 処理の共通化するべき

import Foundation

struct CurrentVelocity{
    var initalSpeed: Double
    mutating func handle(currentAcceleration : Double , currentiTimestamp :TimeInterval, beforeMovingPhaseTimeStamp: TimeInterval) -> Double{
        let speed = initalSpeed + ((currentiTimestamp - beforeMovingPhaseTimeStamp) * currentAcceleration)
        initalSpeed = speed
        return speed
    }
}
