//
// Created by koyanagi on 2021/11/05.
//

import Foundation

struct TurningChecker {

    let mimYawingAngle: Double
    let maxYawingAngle: Double = 180
    // ギルランデになっているかどうか
    //ギルランでってフォールラインに向いたらだめなんだよね　ターン担っていない場合ギルランでと判定したい。
    // ギルランデ　ターンサイドは変わる　フォールラインに板が向かない。
    func isTurning(startYaw: Double, turnEndYaw: Double) -> Bool {
        // true + is turn right
        abs(TwoAngleDifferential.handle(angle: startYaw,
                secondAngle: turnEndYaw)) >= mimYawingAngle
    }

}
