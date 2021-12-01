//
// Created by koyanagi on 2021/11/16.
// TODO: 処理の共通化するべき

import Foundation

struct Calc{
    let bodyO: IsMovingDiscriminator
    let bodyF: IsMovingDiscriminator
    let skiO: IsMovingDiscriminator
    let skiF: IsMovingDiscriminator
}
struct Distance{
    let bodyODis: Double
    let bodyFDis: Double
}

struct TurnVelocity{
    let bodyO: Double
    let bodyF: Double
    let skiO: Double
    let skiF: Double
}
struct CurrentVelocity {

    static func turnVelocity(
            movingPhases: [UnifiedTurnPhase]
    ) -> TurnVelocity {
        let moveFromLast :[UnifiedTurnPhase] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        if moveFromLast.count == 0 {
            return TurnVelocity.init(bodyO: 0, bodyF: 0, skiO: 0, skiF: 0)
        }
        var skiAfterSeconds: TimeInterval = moveFromLast.first!.bodyTimeStampSince1970
        var bodyAfterSeconds: TimeInterval = moveFromLast.first!.skiTimeStampSince1970
        let cMap = moveFromLast.map { (move: UnifiedTurnPhase) -> Calc in
            let elapsed: TimeInterval = bodyAfterSeconds - move.bodyTimeStampSince1970
            let skiElapsed: TimeInterval = skiAfterSeconds - move.bodyTimeStampSince1970
            bodyAfterSeconds = move.bodyTimeStampSince1970
            skiAfterSeconds = move.skiTimeStampSince1970
            return Calc.init(bodyO: IsMovingDiscriminator.init(acceleration:
                                                                move.bodyFallLineAcceleration.y,
                                               timeElapsedFromBeforePhase: elapsed),
                bodyF:
                    IsMovingDiscriminator.init(acceleration:
                                                move.bodyFallLineAcceleration.y,
                                               timeElapsedFromBeforePhase: elapsed),
            skiO: IsMovingDiscriminator.init(acceleration:
                                                move.skiFallLineOrthogonalAcceleration.y,
                                             timeElapsedFromBeforePhase: skiElapsed),
                      skiF: IsMovingDiscriminator.init(acceleration:
                                                        move.skiFallLineAcceleration.y,
                                                       timeElapsedFromBeforePhase: skiElapsed)
            )
        }

        return TurnVelocity.init(bodyO: cMap.map {
            $0.bodyF.distance
        }.reduce(0, +) / cMap.map {
            $0.bodyF.timeElapsedFromBeforePhase
        }.reduce(0, +), bodyF: cMap.map {
            $0.bodyO.distance
        }.reduce(0, +) / cMap.map {
            $0.bodyO.timeElapsedFromBeforePhase
        }.reduce(0, +), skiO: cMap.map {
            $0.skiO.distance
        }.reduce(0, +) / cMap.map {
            $0.skiO.timeElapsedFromBeforePhase
        }.reduce(0, +), skiF: cMap.map {
            $0.skiF.distance
        }.reduce(0, +) / cMap.map {
            $0.skiF.timeElapsedFromBeforePhase
        }.reduce(0, +))
    }
}
