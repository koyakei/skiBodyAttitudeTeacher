//
// Created by koyanagi on 2021/11/12.
//

import Foundation
import CoreMotion

struct Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver {

    var turnPhaseAnalyzer: SkiTurnPhaseAnalyzer
            = SkiTurnPhaseAnalyzer.init()

    mutating func receiver(_ motion: CMDeviceMotion, _ timeStamp: TimeInterval) ->
            SkiTurnPhase {
                let movingPhase = MovingPhase.init(motion, timeStamp)
                
        let v = turnPhaseAnalyzer.handle(movingPhase:
                                            movingPhase)
//        UnifyBodyAndSkiTurn.shared.receive(turnPhase: v)
        return v
    }
}
