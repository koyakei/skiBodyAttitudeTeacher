//
// Created by koyanagi on 2021/11/05.
//

import Foundation

struct TurnSideFinder {

    func handle(startAbsoluteYaw: Double,endAbsoluteYaw: Double)-> TurnSide{
        TurnSide(TwoAngleDiffrencial.handle(angle: startAbsoluteYaw,
                secondAngle: endAbsoluteYaw) > 0)
    }

    func handle(startAbsoluteYaw: Double, fallLineAbsoluteYaw:Double , endAbsoluteYaw:Double)-> TurnSide{
        // true + is turn right
        let startToFallLineTurnSide = handle(startAbsoluteYaw: startAbsoluteYaw,
                endAbsoluteYaw: fallLineAbsoluteYaw)
        // true + is turn right
        let fallLineToEndTurnSide = handle(startAbsoluteYaw: fallLineAbsoluteYaw,
                endAbsoluteYaw: endAbsoluteYaw)
        if (startToFallLineTurnSide == TurnSide(true)
                &&
                startToFallLineTurnSide == TurnSide(true)
           ) {
            return TurnSide(true)
        } else if (
                          startToFallLineTurnSide == TurnSide(false)
                                  &&
                                  startToFallLineTurnSide == TurnSide(false)
                  ) {
            return TurnSide(false)
        }

    }
}
