//
// Created by koyanagi on 2021/11/11.
//

import Foundation

// 動いているか加速度の合計や角速度の大きさで測る
// 2秒ぐらい  前後方向のみの速度変化にするか。　リフトだと完全な等速度になるのかなぁ。
// decent じゃなくても検知するし。
//同速度で運動していたら、加速度がない。　でも速度変化があることは期待しよう。
struct MoveStopDiscriminator {
    func handle(
            movingPhases: [MovingPhaseProtocol],
            continuedSeconds: Int = 2,
            minimumVelocityPerSeconds: Double = 2
    ) -> Bool {
        let moveFromLast :[MovingPhaseProtocol] = movingPhases.recentNSecondsFilter(seconds: continuedSeconds)
                .reversed() // sortedのほうが保証できるのか？
        var afterSeconds: TimeInterval = moveFromLast.first!.timeStampSince1970
        return moveFromLast.map {
                    let elapsed: TimeInterval = afterSeconds - $0.timeStampSince1970
                    afterSeconds = $0.timeStampSince1970
                    return IsMovingDiscriminator.init(acceleration:
                    $0.absoluteUserAcceleration.x,
                            timeElapsedFromBeforePhase: elapsed)
                }.handle(minimumVelocityPerSeconds: minimumVelocityPerSeconds)
    }


}

typealias Seconds = Double

struct IsMovingDiscriminator {
    let acceleration: Double
    let timeElapsedFromBeforePhase: Seconds
}

extension Collection where Element == IsMovingDiscriminator {
    func handle(minimumVelocityPerSeconds: Double) -> Bool {
        currentVelocity() > minimumVelocityPerSeconds
    }

    func currentVelocity() -> Double {
        self.map {
            PhysicsConstants.accelerationToVelocity(
                    accelerationByG: $0.acceleration, elapsedTime: $0.timeElapsedFromBeforePhase
            )
        }.reduce(0, +) / self.map {
            $0.timeElapsedFromBeforePhase
        }.reduce(0, +)
    }

}
