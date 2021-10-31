//
//  設置状況補正.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/29.
//

import Foundation

class 設置状況補正{
    //裏側においたとき ひっくり返す。
    // 裏返し　roll 反転　pitch 反転 yaw 反転
    func boardRideingPhoneAttitudeConverter(attitude: TrunPhase.Attitude) -> WatchMotion.Attitude{
        WatchMotion.Attitude.init(roll: attitude.roll * -1, yaw: attitude.yaw * -1, pitch: attitude.pitch * -1)
    }
}
