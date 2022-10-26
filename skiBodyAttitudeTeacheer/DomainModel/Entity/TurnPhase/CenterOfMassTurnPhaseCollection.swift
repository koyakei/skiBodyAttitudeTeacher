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

final public class BeforeSkiTurn {
    var skiTurnPhases: [SkiTurnPhase] = []
    var beforeSkiTurnPhase: [SkiTurnPhase] = []
    
    func turnEnd(){
        getScore()
        // 消して次の
        beforeSkiTurnPhase = skiTurnPhases
        skiTurnPhases = []
    }
    
    func getScore()-> Double{
        let actualPhaseDegreeList: [ActualPhaseDegree] = beforeSkiTurnPhase.map{
            ActualPhaseDegree(timeIntervalSinceStartOfTurn: $0.timeStampSince1970 -
                              beforeSkiTurnPhase[beforeSkiTurnPhase.startIndex].timeStampSince1970,
                              actualDiffrencialAngleSinceStartOfTurn: Double(QuaternionToEullerAngleDifferential.handle(base: QuaternionToEullerAngleDifferential.matrixDoubleToFloat(val:$0.currentAttitude)
                                                                                                                        , target:
                                                                                            QuaternionToEullerAngleDifferential.matrixDoubleToFloat(val: beforeSkiTurnPhase[beforeSkiTurnPhase.startIndex].currentAttitude)
                                                ).z))
            
            }
        // 現在の角度差が出てくる
        let oneTurnDiffrencial : Double = Double(QuaternionToEullerAngleDifferential.handle(base: QuaternionToEullerAngleDifferential.matrixDoubleToFloat(val:beforeSkiTurnPhase[beforeSkiTurnPhase.endIndex].currentAttitude)
                                                                                , target:
                                                    QuaternionToEullerAngleDifferential.matrixDoubleToFloat(val: beforeSkiTurnPhase[beforeSkiTurnPhase.startIndex].currentAttitude)
        ).z)
        let oneTurnTimeDuration : TimeInterval =
        beforeSkiTurnPhase[beforeSkiTurnPhase.endIndex].timeStampSince1970 - beforeSkiTurnPhase[beforeSkiTurnPhase.startIndex].timeStampSince1970
        return YawingShapeScore(actualPhaseDegreeList: actualPhaseDegreeList, oneTurnDiffrencial: oneTurnDiffrencial, oneTurnTimeDuration: oneTurnTimeDuration).handle()
    }
}
final public class UnifyBodyAndSkiTurn {
    var skiTurnPhases: [SkiTurnPhase] = []
    var bodyTurnPhases: [CenterOfMassTurnPhase] = []
    public static let shared = UnifyBodyAndSkiTurn()

    fileprivate init() {
    }

    func ac()-> (Double,Double){
        let moveFromLast :[SkiTurnPhase] = []// sortedのほうが保証できるのか？
        if moveFromLast.count < 10 {
            return ( 0, 0)
        }
        var skiAfterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        let cMap = moveFromLast[1...moveFromLast.count - 1].map { (move: SkiTurnPhase) -> IsMovingDiscriminator in
            let skiElapsed: TimeInterval = skiAfterSeconds - move.timeStampSince1970
            skiAfterSeconds = move.timeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
//                                                               move.orthogonalAccelerationAndRelativeAttitude.targetDirectionAcceleration
                                              move.fallLineAcceleration
                                              ,
                                                               timeElapsedFromBeforePhase: skiElapsed)
        }
        skiTurnPhases.removeAll()
        let dis = cMap.map {
            $0.distance
        }.reduce(0, +)
        
        let time = cMap.map {
            $0.timeElapsedFromBeforePhase
        }.reduce(0, +)
        return (dis / time,
                0)
    }
    func receive(turnPhase: SkiTurnPhase) {
        skiTurnPhases.append(turnPhase)
    }

    func receive(turnPhase: CenterOfMassTurnPhase) {
        bodyTurnPhases.append(turnPhase)
//        unifyWithSkiTurnPhases()
    }

    func unifyWithSkiTurnPhases() {
        if skiTurnPhases.count > 0 || bodyTurnPhases.count > 0 {
            let turnPhase: SkiTurnPhase = skiTurnPhases.last!
            let bodyTurnPhase: CenterOfMassTurnPhase? = bodyTurnPhases
                    .sortedByNearSkiPhase(skiTurnPhase: turnPhase).first
            if bodyTurnPhase != nil {
//                let rest = UnifiedTurnPhase.init(
//                        skiTurnPhase: turnPhase, centerOfMassTurnPhase: bodyTurnPhase!
//                )
                bodyTurnPhases.removeFirst()
                skiTurnPhases.removeLast()
//                TurnPhaseCutter.shared.receive(unifiedTurnPhase: rest)
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
