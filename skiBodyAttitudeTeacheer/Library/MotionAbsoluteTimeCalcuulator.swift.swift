//
//  MotionAbsoluteTimeCalcuulator.swift.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

struct MotionAbsoluteTimeCaluclator{
    let timeStapm: TimeInterval
    let systemUptime: TimeInterval
    let absoluteDate: Date
    let milsecStringHHmmssSSS: String
    
    init(timeStamp: TimeInterval,systemUptime: TimeInterval){
        absoluteDate = Date(timeInterval: timeStapm, since: Date.now.addingTimeInterval( systemUptime * -1))
        let format = DateFormatter()
            format.dateFormat = "HH:mm:ss.SSS"
        milsecStringHHmmssSSS = format.string(from: absoluteDate)
    }
}
