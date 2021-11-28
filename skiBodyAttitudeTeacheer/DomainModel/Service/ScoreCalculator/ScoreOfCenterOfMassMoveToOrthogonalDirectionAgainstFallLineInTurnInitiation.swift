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

    var skiTurnEndFallLineDirectionVelocity: Double {
        get {
            CurrentVelocity.skiFallLineOrthogonalVelocity(
                    movingPhases: skiTurnPhaseTurnMaxToTurnSwitch
            )
        }
    }

    var skiTurnInitiationFallLineDirectionVelocity: Double {
        get {
            CurrentVelocity.skiFallLineOrthogonalVelocity(
                    movingPhases: skiTurnPhaseTurnSwitchToTurnMax
            )
        }
    }

    var bodyTurnEndFallLineDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnMaxToTurnSwitch
            )
        }
    }

    var bodyTurnInitiationFallLineDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnSwitchToTurnMax
            )
        }
    }

    var skiTurnEndFallLineOrthogonalDirectionVelocity: Double {
        get {
            CurrentVelocity.skiFallLineOrthogonalVelocity(
                    movingPhases: skiTurnPhaseTurnMaxToTurnSwitch
            )
        }
    }

    var skiTurnInitiationFallLineOrthogonalDirectionVelocity: Double {
        get {
            CurrentVelocity.skiFallLineOrthogonalVelocity(
                    movingPhases: skiTurnPhaseTurnSwitchToTurnMax
            )
        }
    }

    var bodyTurnEndFallLineOrthogonalDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnMaxToTurnSwitch
            )
        }
    }

    var bodyTurnInitiationFallLineOrthogonalDirectionVelocity: Double {
        get {
            CurrentVelocity.bodyFallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnSwitchToTurnMax
            )
        }
    }

    //
    func score() -> Double {
//        skiTurnEndFallLineDirectionVelocity * 3600 / 1000// k/h 時速になおしてみよう
        bodyTurnInitiationFallLineOrthogonalDirectionVelocity * 3600 / 1000
//        turnMaxInsideDirectionVelocity / turnSwitchNextOutsideDirectionVelocity // ターン切り替えわりざんすっか？　でも一緒にならないんじゃない？
        // ターンマックスが　スキーの動きなら速度は変わらないだろう割り算で機能するなぁ
        //turnMaxInsideDirectionVelocity こっちが大きいと　turnMaxInsideDirectionVelocity
//        もおおきくなりそうだな
    }
}
