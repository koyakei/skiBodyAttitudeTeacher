//
//  FinishedTurns.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/05.
//

import Foundation
struct FinishedTurns{
    var finishedTurns: [OneFinisedMonoSkiTurn] = []
    var defaultFallLineYaw: Double = .zero
    let defaultRollBase: Double = .zero
    func finishedTowTurnSaved() -> Bool{
        return finishedTurns.count >= 2
    }
    
    func absoluteFallLineYaw() -> Double{
        switch finishedTurns.count{
        case 0:
            return defaultFallLineYaw
        case 1:
            return  finishedTurns.first!.turnMaxPhase().turnPhase.attitude.yaw as Double
        default:
            return TwoAngleDDiffrencial.handle(angle: finishedTurns.last!.turnMaxPhase().turnPhase.attitude.yaw , secondAngle: finishedTurns[finishedTurns.count - 2].turnMaxPhase().turnPhase.attitude.yaw)
        }
    }
}
