//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct SkiTurnPhaseWithFallLineAttitude: MovingPhaseProtocol {
    var attitude: Attitude
    let userAcceleration: CMAcceleration
    let timeStampSince1970: TimeInterval
    let rotationRate: CMRotationRate
    let skiFallLineAcceleration: Double
    let fallLineAbsoluteAttitude: Attitude
    let fallLineRelativeAttitude: Attitude

    init(turnPhase: TurnPhaseProtocol, fab: Attitude) {
        fallLineAbsoluteAttitude = fab
        fallLineRelativeAttitude = Attitude.init(roll: fab.roll - turnPhase.attitude.roll, yaw: fab.yaw - turnPhase.attitude.yaw,
                pitch: fab.pitch - turnPhase.attitude.pitch)
        skiFallLineAcceleration = turnPhase.userAcceleration.x * cos(fallLineRelativeAttitude.yaw) * cos(fallLineRelativeAttitude.pitch)
                + turnPhase.userAcceleration.y * cos(fallLineRelativeAttitude.yaw) * cos(fallLineRelativeAttitude.roll)
                + turnPhase.userAcceleration.z * cos(fallLineRelativeAttitude.pitch) * cos(fallLineRelativeAttitude.roll)
        attitude = turnPhase.attitude
        userAcceleration = turnPhase.userAcceleration
        timeStampSince1970 = turnPhase.timeStampSince1970
        rotationRate = turnPhase.rotationRate
    }
}
