//
// Created by koyanagi on 2021/11/19.
//

import Foundation
extension Collection where Element == CenterOfMassTurnPhase {
    func filterByTimeStamp(startedAt: TimeInterval, endAt:TimeInterval) -> [CenterOfMassTurnPhase]{
        self.filter{
            startedAt <= $0.timeStampSince1970
                    && $0.timeStampSince1970 <= endAt
        }
    }

    // 近くのTurnPhaseをみつけて　fall line 方向を発見　加速度を計算して変換する
    func unifyWithSkiTurnPhases(skiTurnPhases:[SkiTurnPhase])->[UnifiedTurnPhase] {
        var res :[UnifiedTurnPhase] = []
        // 一番近いのを見つける　sorted fast
        for turnPhase  in skiTurnPhases{
            let pairedPhase  =
                    self.filterByTimeStamp(startedAt:
                                           Date(timeInterval: -0.01 ,since: Date.init(
                                                   timeIntervalSince1970: turnPhase.timeStampSince1970)).timeIntervalSince1970,
                                           endAt: Date(timeInterval: 0.02 ,since: Date.init(
                                                   timeIntervalSince1970: turnPhase.timeStampSince1970)).timeIntervalSince1970
                    ).sorted(by: {
                        nearByPhase(
                                turnPhase: turnPhase,
                                centerOfMassTurnPhase1: $0, centerOfMassTurnPhase2: $1)
                    }).first ??
                            self.sorted(by: {
                                nearByPhase(
                                        turnPhase: turnPhase,
                                        centerOfMassTurnPhase1: $0, centerOfMassTurnPhase2: $1)
                            }).first!
            res.append(
                    UnifiedTurnPhase.init(
                            skiTurnPhase:turnPhase, centerOfMassTurnPhase: pairedPhase
                    )
            )
        }
        return res
    }

    func nearByPhase(turnPhase: SkiTurnPhase,
                     centerOfMassTurnPhase1:CenterOfMassTurnPhase,
                     centerOfMassTurnPhase2:CenterOfMassTurnPhase) -> Bool{
        abs(centerOfMassTurnPhase1.timeStampSince1970 - turnPhase.timeStampSince1970) <
                abs(centerOfMassTurnPhase2.timeStampSince1970 - turnPhase.timeStampSince1970)

    }
}
