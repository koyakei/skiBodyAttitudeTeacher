//
//  turnStreamReceiver.swift.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/30.
//

import Foundation
// ターンストリームを headphone iphone watch から受け取る
//受け取り部位ごとに分けるか。

protocol MotionStreamReceiver{
    var  movingPhases:[MovingPhase]{get}
    
    mutating func receiver(movingPhase: MovingPhase)
}
