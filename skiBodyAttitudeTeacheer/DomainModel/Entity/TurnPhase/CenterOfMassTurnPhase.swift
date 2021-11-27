//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import CoreMotion

struct CenterOfMassTurnPhase {
    let turnYawingSide: TurnYawingSide
    let turnSwitchingDirection: TurnSwitchingDirection
    let turnSideChangePeriod: TimeInterval
    let absoluteFallLineAttitude: Attitude
    let turnPhase: TurnChronologicalPhase
    let fallLineOrthogonalAccelerationAndRelativeAttitude:
            TargetDirectionAccelerationAndRelativeAttitude

    let timeStampSince1970: TimeInterval

    let rotationRate: CMRotationRate
}
