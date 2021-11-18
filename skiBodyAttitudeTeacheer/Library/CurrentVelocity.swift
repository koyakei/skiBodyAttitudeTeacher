//
// Created by koyanagi on 2021/11/16.
//

import Foundation

struct CurrentVelocity {

    static func fallLineVelocity(
            movingPhases: [TurnPhaseYawSimpleRotationRateAverageProtocol]
    ) -> Double {
        let moveFromLast :[TurnPhaseYawSimpleRotationRateAverageProtocol] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        var afterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        return moveFromLast.map {
            var elapsed: TimeInterval = afterSeconds - $0.timeStampSince1970
            afterSeconds = $0.timeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
            $0.fallLineAcceleration,
                    timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }

    static func fallLineOrthogonalVelocity(
            movingPhases: [TurnPhaseYawSimpleRotationRateAverageProtocol]
    ) -> Double {
        let moveFromLast :[TurnPhaseYawSimpleRotationRateAverageProtocol] = movingPhases
                .reversed() // sortedのほうが保証できるのか？
        var afterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        return moveFromLast.map {
            var elapsed: TimeInterval = afterSeconds - $0.timeStampSince1970
            afterSeconds = $0.timeStampSince1970
            return IsMovingDiscriminator.init(acceleration:
            $0.fallLineOrthogonalAcceleration,
                    timeElapsedFromBeforePhase: elapsed)
        }.currentVelocity()
    }
}
