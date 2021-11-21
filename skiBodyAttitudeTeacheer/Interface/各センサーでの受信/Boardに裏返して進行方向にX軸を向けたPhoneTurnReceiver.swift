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

    mutating func receiver(_ motion: CMDeviceMotion, _ timeStamp: TimeInterval) -> TurnYawingSide{
        turnPhaseAnalyzer.handle(movingPhase:
                 MovingPhase.init(motion, timeStamp))
    }
}
