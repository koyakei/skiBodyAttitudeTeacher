//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion
import simd

struct SkiTurnPhase : TooMuchInsideAngleFinderProtocol{
    let turnYawingSide: TurnYawingSide
    let turnSwitchingDirection: TurnSwitchingDirection
    let turnSideChangePeriod: TimeInterval
    let absoluteFallLineAttitude: simd_quatd
    let fallLineAcceleration: Double
    let turnPhase: TurnPhaseByStartMaxEnd
    let orthogonalAccelerationAndRelativeAttitude:
    TargetDirectionAccelerationAndRelativeAttitude
    let absoluteAttitude: Attitude
    let timeStampSince1970: TimeInterval
    let absoluteAcceleration: CMAcceleration
    let rotationRate: CMRotationRate
    let fallLineAttitude: Attitude
    let turnPhaseBy100: Double
    let lastSwitchedTurnAngle : simd_quatf
}

struct ElapsedTimeAndV{
    let elapsedTime : Double
    let velocity: Double
}
extension Collection where Element == SkiTurnPhase{
    func filterTurnInitialize()->[SkiTurnPhase]{
        return self.filter{
            $0.turnPhase == TurnPhaseByStartMaxEnd.SwitchToMax
        }
    }

    func filterTurnEnd()-> [SkiTurnPhase]{
        return self.filter{
            $0.turnPhase == TurnPhaseByStartMaxEnd.MaxToSwitch
        }
    }

    func firstAndLastTimeStamp()-> (TimeInterval,TimeInterval){
        let v = self.sorted(by:
        {$0.timeStampSince1970 > $1.timeStampSince1970}
        )
        return  (v.last?.timeStampSince1970 ?? Date.now.timeIntervalSince1970,
                      v.first?.timeStampSince1970 ?? Date.now.timeIntervalSince1970)
    }

}


