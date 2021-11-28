//
// Created by koyanagi on 2021/11/13.
//

import Foundation





// ターン前半
// ヘッドフォンの加速度センサーの分析結果の横方向の移動量を確かめる
// 渡されるのは 1ターンごとにするか
struct ScoreOfCenterOfMassMoveToOrthogonalDirectionAgainstFallLineInTurnInitiation {
    //時間方向に同じフレームに入れることもできるが
    let skiTurnPhaseTurnSwitchToTurnMax: [SkiTurnPhase] //  ターンマックスまでを取り出す？
    let skiTurnPhaseTurnMaxToTurnSwitch: [SkiTurnPhase]
    let centerOfMassTurnPhaseTurnSwitchToTurnMax: [UnifiedTurnPhase]
    let centerOfMassTurnPhaseTurnMaxToTurnSwitch: [UnifiedTurnPhase]

    var turnMaxInsideDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnSwitchToTurnMax
            )
        }
    }// G そのままのほうがあつかいやすいか？ 9.8 m/s
    var turnSwitchNextOutsideDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnMaxToTurnSwitch
            )
        }
    }// ターン切替時の速度

    //
    func score() -> Double {
        turnMaxInsideDirectionVelocity * PhysicsConstants.G * 3600 / 1000// そのまま返すか 時速になおしてみよう
//        turnMaxInsideDirectionVelocity / turnSwitchNextOutsideDirectionVelocity // ターン切り替えわりざんすっか？　でも一緒にならないんじゃない？
        // ターンマックスが　スキーの動きなら速度は変わらないだろう割り算で機能するなぁ
        //turnMaxInsideDirectionVelocity こっちが大きいと　turnMaxInsideDirectionVelocity
//        もおおきくなりそうだな
    }
}
