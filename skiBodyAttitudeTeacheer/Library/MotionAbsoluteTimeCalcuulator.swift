//
//  MotionAbsoluteTimeCalcuulator.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

struct TimeIntervalFromSystemUptimeToSince1970 {
    let timeStamp: TimeInterval
    let systemUptime: TimeInterval
    let absoluteDate: Date
    let milliSecondString: String
    
    init(timeStamp: TimeInterval,systemUptime: TimeInterval){
        absoluteDate = Date(timeInterval: timeStamp, since: Date.now.addingTimeInterval( systemUptime * -1))
        let format = DateFormatter()
            format.dateFormat = "HH:mm:ss.SSS"
        milliSecondString = format.string(from: absoluteDate)
    }
}
