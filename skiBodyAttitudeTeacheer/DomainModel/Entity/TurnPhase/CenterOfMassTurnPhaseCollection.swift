//
// Created by koyanagi on 2021/11/19.
//

import Foundation

public struct TurnPhaseCutter {
    var unifiedTurns: [UnifiedTurnPhase] = []
    public static var shared = TurnPhaseCutter()

    fileprivate init() {
    }

    mutating func receive(unifiedTurnPhase: UnifiedTurnPhase) {
        unifiedTurns.append(unifiedTurnPhase)
    }

    mutating func getOneTurn() -> [UnifiedTurnPhase] {
        let v : [UnifiedTurnPhase] = unifiedTurns.filterTurnInitialize()
        unifiedTurns.removeAll()
        return v
    }
}

struct UnifyBodyAndSkiTurn {
    var skiTurnPhases: [SkiTurnPhase] = []
    var bodyTurnPhases: [CenterOfMassTurnPhase] = []
    public static var shared = UnifyBodyAndSkiTurn()

    fileprivate init() {
    }

    mutating func receive(turnPhase: SkiTurnPhase) {
        skiTurnPhases.append(turnPhase)
    }

    mutating func receive(turnPhase: CenterOfMassTurnPhase) {
        bodyTurnPhases.append(turnPhase)
        unifyWithSkiTurnPhases()
    }

    mutating func unifyWithSkiTurnPhases() {
        if skiTurnPhases.count > 0 || bodyTurnPhases.count > 0 {
            let turnPhase: SkiTurnPhase = skiTurnPhases.last!
            let bodyTurnPhase: CenterOfMassTurnPhase? = bodyTurnPhases
                    .sortedByNearSkiPhase(skiTurnPhase: turnPhase).first
            if bodyTurnPhase != nil {
                let rest = UnifiedTurnPhase.init(
                        skiTurnPhase: turnPhase, centerOfMassTurnPhase: bodyTurnPhase!
                )
                bodyTurnPhases.removeFirst()
                skiTurnPhases.removeLast()
                TurnPhaseCutter.shared.receive(unifiedTurnPhase: rest)
            }
        }
    }
}

extension Collection where Element == CenterOfMassTurnPhase {

    func sortedByNearSkiPhase(skiTurnPhase: SkiTurnPhase) -> [Element] {
        self.sorted(by: {
            self.nearByPhase(
                    turnPhase: skiTurnPhase,
                    centerOfMassTurnPhase1: $0, centerOfMassTurnPhase2: $1)
        })
    }

    func filterByTimeStamp(startedAt: TimeInterval, endAt: TimeInterval) -> [CenterOfMassTurnPhase] {
        self.filter {
            startedAt <= $0.timeStampSince1970
                    && $0.timeStampSince1970 <= endAt
        }
    }

    // 近くのTurnPhaseをみつけて　fall line 方向を発見　加速度を計算して変換する


    func nearByPhase(turnPhase: SkiTurnPhase,
                     centerOfMassTurnPhase1: CenterOfMassTurnPhase,
                     centerOfMassTurnPhase2: CenterOfMassTurnPhase) -> Bool {
        abs(centerOfMassTurnPhase1.timeStampSince1970 - turnPhase.timeStampSince1970) <
                abs(centerOfMassTurnPhase2.timeStampSince1970 - turnPhase.timeStampSince1970)

    }
}
