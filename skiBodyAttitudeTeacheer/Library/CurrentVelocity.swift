//
// Created by koyanagi on 2021/11/16.
// TODO: 処理の共通化するべき

import Foundation

struct CurrentVelocity {
    static func bodyFallLineOrthogonalVelocity(
            movingPhases: [UnifiedTurnPhase]
    ) -> Double {
        
        let moveFromLast :[UnifiedTurnPhase] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        if moveFromLast.count == 0 {
            return 0
        }
        var afterSeconds: TimeInterval = moveFromLast.first!.bodyTimeStampSince1970
        return moveFromLast.map {
            let elapsed: TimeInterval = afterSeconds - $0.bodyTimeStampSince1970
            afterSeconds = $0.bodyTimeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
                                              $0.bodyFallLineOrthogonalAcceleration,
                                              timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }

    
    static func bodyFallLineVelocity(
            movingPhases: [UnifiedTurnPhase]
    ) -> Double {
        let moveFromLast :[UnifiedTurnPhase] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        if moveFromLast.count == 0 {
            return 0
        }
        var afterSeconds: TimeInterval = moveFromLast.first!.bodyTimeStampSince1970
        // 最初が除外されてないんじゃない？
        return moveFromLast.map {
            let elapsed: TimeInterval = afterSeconds - $0.bodyTimeStampSince1970
            afterSeconds = $0.bodyTimeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
            $0.bodyFallLineAcceleration,
                    timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }

    static func skiFallLineVelocity(
            movingPhases: [SkiTurnPhase]
    ) -> Double {
        let moveFromLast :[SkiTurnPhase] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        var afterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        return moveFromLast.map {
            let elapsed: TimeInterval = afterSeconds - $0.timeStampSince1970
            afterSeconds = $0.timeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
            $0.fallLineAcceleration,
                    timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }

    static func skiFallLineOrthogonalVelocity(
            movingPhases: [SkiTurnPhase]
    ) -> Double {
        let moveFromLast :[SkiTurnPhase] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        var afterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        return moveFromLast.map {
            var elapsed: TimeInterval = afterSeconds - $0.timeStampSince1970
            afterSeconds = $0.timeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
            $0.orthogonalAccelerationAndRelativeAttitude.targetDirectionAcceleration,
                    timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }
}
