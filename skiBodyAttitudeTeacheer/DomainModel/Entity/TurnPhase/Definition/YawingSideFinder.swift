//
// Created by koyanagi on 2021/11/19.
//

import Foundation
import CoreMotion

extension CMRotationRate {
    var yawingSide: TurnYawingSide {
        get{
            switch z {
            case -.infinity..<PhysicsConstants.degree * -1:
                return TurnYawingSide.RightYawing
            case PhysicsConstants.degree...Double.infinity:
                return TurnYawingSide.LeftYawing
            default:
                return TurnYawingSide.Straight
            }
        }
    }
}
