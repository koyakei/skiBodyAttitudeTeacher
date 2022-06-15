//
// Created by koyanagi on 2021/11/11.
//

import Foundation


typealias Seconds = Double

struct IsMovingDiscriminator {
    let acceleration: Double
    let timeElapsedFromBeforePhase: Seconds
    let distance : Double

    init(acceleration: Double,timeElapsedFromBeforePhase: Seconds){
        self.acceleration = acceleration
        self.timeElapsedFromBeforePhase = timeElapsedFromBeforePhase
        distance = PhysicsConstants.距離(
                accelerationByG: acceleration, elapsedTime: timeElapsedFromBeforePhase
        )
    }
}

extension Collection where Element == IsMovingDiscriminator {
    func handle(minimumVelocityPerSeconds: Double) -> Bool {
        currentVelocity() > minimumVelocityPerSeconds
    }

    // 現在の速度　m/s
    //　どうやって出すの？ 進んだ距離を出そう。
    func currentVelocity() -> Double {
        self.map {
            $0.distance
        }.reduce(0, +) / self.map {
            $0.timeElapsedFromBeforePhase // 時間
        }.reduce(0, +)
    }

}
