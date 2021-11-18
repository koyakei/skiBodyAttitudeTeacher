//
// Created by koyanagi on 2021/11/12.
//

import Foundation
import CoreMotion

struct Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver {

    // 一番目のバケツ
    // ターンを切ったバケツ
    var turnPhases: [SkiTurnPhase] =
            []
    var turnPhaseAnalyzer: SkiTurnPhaseAnalyzer
            = SkiTurnPhaseAnalyzer.init()

    //裏側においたとき ひっくり返す。
    // 裏返し　roll 反転　pitch 反転 yaw 反転
    // roll だけ上下にひっくり返す
    func boardRidingPhoneAttitudeConverter(attitude: Attitude) -> Attitude {
        Attitude.init(roll: (Double.pi - attitude.roll) * -1, yaw: attitude.yaw * -1, pitch: attitude.pitch * -1)
    }

    func boardRidingPhoneRotationRateConverter(rotationRate: CMRotationRate) -> CMRotationRate {
        CMRotationRate.init(
                x: rotationRate.x * -1,
                y: rotationRate.y,
                z: rotationRate.z * -1
        )
    }

    mutating func receiver(_ motion: CMDeviceMotion, _ timeStamp: TimeInterval) {
        turnPhaseAnalyzer.handle(movingPhase: MovingPhase
                .init(motion, timeStamp))
    }
}
