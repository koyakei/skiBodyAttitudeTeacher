//
//  MovingPhase.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

// これが基底
protocol MovingPhaseProtocol{
    var attitude: Attitude {get set}
    var userAcceleration: CMAcceleration {get set}
    var timeStampSince1970: TimeInterval {get set}
    var rotationRate: CMRotationRate {get set}
}