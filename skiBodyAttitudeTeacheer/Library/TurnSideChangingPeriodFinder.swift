//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import CoreMotion

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
//    var rotationRateRecords: [RotationRateRecord] = []
    var lastTurnSiwtchedTimeInterval = Date.now.timeIntervalSince1970
    let minimumTurnPeriod : TimeInterval = 0.7
    let rotationNoizeRange: Range<Double> = (Measurement(value: -10
                                            , unit: UnitAngle.degrees)
                                    .converted(to: .radians).value)..<Measurement(value: 10
                                                                                  , unit: UnitAngle.degrees)
                                                                          .converted(to: .radians).value
    mutating func handle(cMRotationRate: CMRotationRate, timeInterval : TimeInterval)-> Bool{
//        rotationRateRecords.append(RotationRateRecord.init(absoluteRotationRate: cMRotationRate, timeStampSince1970: timeInterval))
//        let v = rotationRateRecords.yawRotationRateMovingAverage(timeInterval: minimumTurnPeriod)
        
        if rotationNoizeRange ~= cMRotationRate.z
            && (Date.now.timeIntervalSince1970 - lastTurnSiwtchedTimeInterval) > minimumTurnPeriod {
            lastTurnSiwtchedTimeInterval = timeInterval
            return true
        }
        return false
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
