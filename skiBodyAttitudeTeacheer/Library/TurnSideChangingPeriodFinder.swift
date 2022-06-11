//
// Created by koyanagi on 2021/11/18.
//

import Foundation

struct TurnSideChangingPeriodFinder {
    var lastSwitchedTurnSideTimeStamp: TimeInterval = Date.now.timeIntervalSince1970
    

    mutating func handle
    (currentTimeStampSince1970: TimeInterval, isTurnSwitching: Bool) -> TimeInterval {
        let period = currentTimeStampSince1970 - lastSwitchedTurnSideTimeStamp
       if (isTurnSwitching)  {
            lastSwitchedTurnSideTimeStamp = currentTimeStampSince1970
        }
        return period
    }
}



struct TurnSwitchingTimingFinder{
    var yawingSideRecords: [TurnYawingSide] = []
    mutating func handle(currentYawingSide: TurnYawingSide)-> Bool{
        // 　左ターンが続いていて、ヨーイングサイドが逆になったら
//        if ((yawingSideRecords.isLeftYawingContinued() && currentYawingSide == TurnYawingSide.RightYawing) ||
//            (yawingSideRecords.isRightYawingContinued() && currentYawingSide == TurnYawingSide.LeftYawing)){
//             yawingSideRecords = []
//        return true
//         }
//        yawingSideRecords.append(currentYawingSide)
        yawingSideRecords.append(currentYawingSide)
        let v = yawingSideRecords.isTurnSideSwitched()
        if v {
            yawingSideRecords.removeAll()
        }
        return v
    }
}

struct TurnInFirstPhaseBorder {
    var isPassed1to3 : Bool = false
    
    mutating func handle(isTurnSwitching: Bool, turnPhaseBy100: Float, angleRange: Range<Float>) -> Bool {
        if isTurnSwitching{
            isPassed1to3 = false
        }
        if  angleRange ~= turnPhaseBy100{
            isPassed1to3 = true
            return true
        }
        return false
    }
}
