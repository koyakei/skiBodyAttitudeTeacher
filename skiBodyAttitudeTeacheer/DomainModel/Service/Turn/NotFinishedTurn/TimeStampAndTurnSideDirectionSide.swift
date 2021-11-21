//
// Created by koyanagi on 2021/11/13.
//

import Foundation

struct TimeStampAndTurnSideDirectionSide {
    // 右ターン  true left false
    let turnPhase: TurnPhaseProtocol.Protocol
    let timeStampSince1970: Double
}

struct TurnSwitchingDirectionFinder{
    var lastYawingSide: TurnYawingSide = TurnYawingSide.Straight
    mutating func handle
            (currentTimeStampSince1970: TimeInterval, currentYawingSide: TurnYawingSide) -> TurnSwitchingDirection {
        switch (lastYawingSide, currentYawingSide){
        case(.Straight, .LeftYawing):
            return .StraightToLeftTurn
        case (.Straight, .RightYawing):
            return .StraightToRightTurn
        case (.RightYawing, .LeftYawing):
            return .RightToLeft
        case (.LeftYawing, .RightYawing):
            return .LeftToRight
        case (.LeftYawing, .Straight):
            return .RightTurnToStraight
        case (.RightYawing, .Straight):
            return .RightTurnToStraight
        default:
            return .Keep
        }
    }
}