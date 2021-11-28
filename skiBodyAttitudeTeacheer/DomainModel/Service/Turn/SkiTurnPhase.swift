//
// Created by koyanagi on 2021/11/05.
//

import Foundation
import CoreMotion

struct SkiTurnPhase {
    let turnYawingSide: TurnYawingSide
    let turnSwitchingDirection: TurnSwitchingDirection
    let turnSideChangePeriod: TimeInterval
    let absoluteFallLineAttitude: Attitude
    let fallLineAcceleration: Double
    let turnPhase: TurnChronologicalPhase
    let orthogonalAccelerationAndRelativeAttitude:
    TargetDirectionAccelerationAndRelativeAttitude
    let absoluteAttitude: Attitude
    let timeStampSince1970: TimeInterval
    let absoluteAcceleration: CMAcceleration
    let rotationRate: CMRotationRate
}

extension Collection where Element == SkiTurnPhase{
    func filterTurnInitialize()->[SkiTurnPhase]{
        return self.filter{
            $0.turnPhase == TurnChronologicalPhase.SwitchToMax
        }
    }

    func filterTurnEnd()-> [SkiTurnPhase]{
        return self.filter{
            $0.turnPhase == TurnChronologicalPhase.MaxToSwitch
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


