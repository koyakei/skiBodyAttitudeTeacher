//
//  MovingPhasesProtocol.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

protocol MovingPhaseProtocol {
    var attitude: Attitude { get }
    var userAcceleration: CMAcceleration { get }
    var timeStampSince1970: TimeInterval { get }
    var rotationRate: CMRotationRate { get }
    var absoluteRotationRate: CMRotationRate { get }
}