//
//  TooMuchInsideRollAngleFinder..swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/12/10.
//

import Foundation
import CoreMotion

protocol TooMuchInsideAngleFinderProtocol{
    var rotationRate: CMRotationRate {get}
    var turnYawingSide: TurnYawingSide {get}
    var turnPhase: TurnPhaseByStartMaxEnd {get}
    var badRollRotationRate : Bool {get}
}
// roll がターンマックス以後に角速度が逆になっていかない

extension TooMuchInsideAngleFinderProtocol {
    var badRollRotationRate : Bool {
        get {
            if turnPhase == .MaxToSwitch{
            switch turnYawingSide{
            case .LeftYawing:
                return rotationRate.y.sign == .minus
            case .RightYawing:
                return rotationRate.y.sign == .plus
            case .Straight:
                return false
            }
            } else {
                switch turnYawingSide{
                case .LeftYawing:
                    return rotationRate.y.sign == .plus
                case .RightYawing:
                    return rotationRate.y.sign == .minus
                case .Straight:
                    return false
                }
            }
        }
    }
}
