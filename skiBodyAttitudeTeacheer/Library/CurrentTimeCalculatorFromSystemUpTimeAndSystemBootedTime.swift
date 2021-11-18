//
//  CurrentTimeCalcuulatorFromSystemUpTimeAndSystemBootedTime.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation

struct CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime {

    static func handle(timeStamp: TimeInterval,
                       systemUptime:
                               TimeInterval) -> TimeInterval {
        Date(timeInterval: timeStamp, since: Date.now
                .addingTimeInterval(systemUptime * -1)).timeIntervalSince1970
    }
}

struct MilliSecondString {
    static func handle(timeStamp: TimeInterval)-> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        format.string(from: Date(timeIntervalSince1970:
                                 timeStamp))
    }
}
