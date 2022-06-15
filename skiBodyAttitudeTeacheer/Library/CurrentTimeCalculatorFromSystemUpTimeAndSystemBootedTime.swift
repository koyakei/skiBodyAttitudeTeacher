//
//  CurrentTimeCalcuulatorFromSystemUpTimeAndSystemBootedTime.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation


struct MilliSecondString {
    static func handle(timeStamp: TimeInterval)-> String {
        let format = DateFormatter()
        format.dateFormat = "HH:mm:ss.SSS"
        return format.string(from: Date(timeIntervalSince1970:
                                 timeStamp))
    }
}
