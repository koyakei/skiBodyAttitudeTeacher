//
// Created by koyanagi on 2021/11/13.
//

import Foundation

extension Collection where Element == SkiTurnPhase {

    func filterLastTurnSwitchToTurnMax() -> [TurnPhase] {
        self.filter {
             self.filter {
                $0.turnSideDirectionChanged == true
            }.last!.timeStampSince1970 < $0.timeStampSince1970
                    && $0.timeStampSince1970 < self.filter {
                $0.isTurnMax == true
            }.last!.timeStampSince1970
        }
    }

    // ターンマックスのときにこれを使う
    // 今ターンマックス
    // 最後のターンマックスからもう一つ前のターンマックスから最後の切り替えまで
    func filterLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax() -> [TurnPhase] {
        self.filter {
            self.filter {
                $0.isTurnMax == true
            }[self.count - 2].timeStampSince1970 < $0.timeStampSince1970
                    && $0.timeStampSince1970 < self.filter {
                $0.turnSideDirectionChanged == true
            }.last!.timeStampSince1970
        }
    }
}

extension Collection where Element == CenterOfMassTurnPhase {
    func filterByTimeStamp(startedAt: TimeInterval, endAt:TimeInterval) -> [CenterOfMassTurnPhase]{
        self.filter{
            startedAt <= $0.timeStampSince1970
            && $0.timeStampSince1970 <= endAt
        }
    }

    // 近くのTurnPhaseをみつけて　fall line 方向を発見　加速度を計算して変換する
    // TODO: 照らし合わせはどうするね
    //
    func unifyWithSkiTurnPhases(skiTurnPhases:[TurnPhase])->[CenterOfMassUnifiedTurnPhase] {
        var res :[CenterOfMassUnifiedTurnPhase] = []
        // 一番近いのを見つける　sorted fast
        for turnPhase  in skiTurnPhases{
            let pairedPhase  =
                    self.filterByTimeStamp(startedAt:
                            Date(timeInterval: -0.01 ,since: Date.init(
                                    timeIntervalSince1970: turnPhase.timeStampSince1970)).timeIntervalSince1970,
                    endAt: Date(timeInterval: 0.02 ,since: Date.init(
                            timeIntervalSince1970: turnPhase.timeStampSince1970)).timeIntervalSince1970
                    ).sorted(by: {
                        nearByPhase(
                                turnPhase: turnPhase,
                                centerOfMassTurnPhase1: $0, centerOfMassTurnPhase2: $1)
                    }).first ??
                    self.sorted(by: {
                nearByPhase(
                        turnPhase: turnPhase,
                        centerOfMassTurnPhase1: $0, centerOfMassTurnPhase2: $1)
            }).first!
            res.append(
                    CenterOfMassUnifiedTurnPhase.init(
                            skiTurnPhase:turnPhase, centerOfMassTurnPhase: pairedPhase
                    )
            )
        }
        return res
    }
    func nearByPhase(turnPhase: TurnPhase,
                     centerOfMassTurnPhase1:CenterOfMassTurnPhase,
                     centerOfMassTurnPhase2:CenterOfMassTurnPhase) -> Bool{
        abs(centerOfMassTurnPhase1.timeStampSince1970 - turnPhase.timeStampSince1970) <
                abs(centerOfMassTurnPhase2.timeStampSince1970 - turnPhase.timeStampSince1970)

    }
}

// ターン前半
// ヘッドフォンの加速度センサーの分析結果の横方向の移動量を確かめる
// 渡されるのは 1ターンごとにするか
struct ScoreOfCenterOfMassMoveToOrthogonalDirectionAgainstFallLineInTurnInitiation {
    //時間方向に同じフレームに入れることもできるが
    let skiTurnPhaseTurnSwitchToTurnMax: [TurnPhase] //  ターンマックスまでを取り出す？
    let skiTurnPhaseTurnMaxToTurnSwitch: [TurnPhase]
    let centerOfMassTurnPhaseTurnSwitchToTurnMax: [CenterOfMassUnifiedTurnPhase]
    let centerOfMassTurnPhaseTurnMaxToTurnSwitch: [CenterOfMassUnifiedTurnPhase]

    var turnMaxInsideDirectionVelocity: Double {
        get {
            CurrentVelocity.fallLineOrthogonalVelocity(
                    movingPhases: centerOfMassTurnPhaseTurnSwitchToTurnMax
            )
        }
    }// G そのままのほうがあつかいやすいか？ 9.8 m/s
    var turnSwitchNextOutsideDirectionVelocity: Double {
        get {
            CurrentVelocity.fallLineOrthogonalVelocity(
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
