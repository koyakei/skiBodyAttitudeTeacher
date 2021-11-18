//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import UIKit

final public class MotionAnalyzerManager {
    var delegate: MotionFeedbackerDelegate =
            MotionFeedBackerImpl.init()
    var unifiedAnalyzedTurnCollection: [OneTurn]
    // motion from board
    // motion from headphone
    // 全部混ぜて評価
    var ariPodMotionReceiver: AirPodOnHeadMotionReceiver = AirPodOnHeadMotionReceiver.init()
    var boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
            = Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.init()
    public static let shared = MotionAnalyzerManager()

    private init() {
    }

    func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) {
        boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion, receivedProcessUptime)
    }

    func receiveAirPodMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) {
        ariPodMotionReceiver.receiver(motion, receivedProcessUptime)
    }

    private func tellTheScore(score: Int) {
        delegate.result(score: score)
    }

    func unify() {
        let skiTurnEnd: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.turnPhases
                        .filterLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax()
        let skiTurnInitiation: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
                        .turnPhases.filterLastTurnSwitchToTurnMax()
        let ti: [CenterOfMassUnifiedTurnPhase] =
                ariPodMotionReceiver.turnPhases.filterByTimeStamp(
                        startedAt: skiTurnEnd.first!.timeStampSince1970,
                        endAt: skiTurnEnd.first!.timeStampSince1970).unifyWithSkiTurnPhases(skiTurnPhases: skiTurnEnd)
        let te: [CenterOfMassUnifiedTurnPhase] = ariPodMotionReceiver
                .turnPhases
                .filterByTimeStamp(
                        startedAt: skiTurnInitiation.first!.timeStampSince1970,
                        endAt: skiTurnInitiation.first!.timeStampSince1970)
                .unifyWithSkiTurnPhases(skiTurnPhases: skiTurnInitiation)
        unifiedAnalyzedTurnCollection.append(
                OneTurn.init(
                        oneSkiTurnLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax: skiTurnEnd,
                        oneSkiTurnLastTurnSwitchToTurnMax: skiTurnInitiation,
                        oneCenterOfMassTurnLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax:
                        ti
                        ,
                        oneCenterOfMassTurnLastTurnSwitchToTurnMax: te)
        )
        // ここに来るのはどうも気に入らない　イベント駆動にするしかなさそうだなぁ　まあしたところで何が変わるかわからんが。
        tellTheScore(score: Int(ScoreOfCenterOfMassMoveToOrthogonalDirectionAgainstFallLineInTurnInitiation.init(
                skiTurnPhaseTurnSwitchToTurnMax: skiTurnInitiation,
                skiTurnPhaseTurnMaxToTurnSwitch: skiTurnEnd,
                centerOfMassTurnPhaseTurnSwitchToTurnMax: te,
                centerOfMassTurnPhaseTurnMaxToTurnSwitch: ti).score())
        )
    }
}

// ターンの前半後半って　スキーとの相対加速度で決まってくるのかな
// スキーのヨーイングのターン前半後半
// 横方向の加速度が　スキー > 重心　　スキー＜重心　なのかの区別して　その２要素で判定するのがいいのかな
// 重心側の前半後半で考える場合があるか？　早すぎる最適化か？　ピボットスリップ　アウトサイド　前後　カービング　リープ　サウザンドステップ
// どれも前半後半だけだな
// 重心の横移動方向の符号では区別できないだろう。スキーの横への相対速度に影響されすぎる
struct OneTurn {
    let
            oneSkiTurnLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax: [SkiTurnPhase]
    let oneSkiTurnLastTurnSwitchToTurnMax: [SkiTurnPhase]
    let oneCenterOfMassTurnLastTurnMaxToTurnSwitchWhenPhaseIsTurnMax: [CenterOfMassUnifiedTurnPhase]
    let oneCenterOfMassTurnLastTurnSwitchToTurnMax: [CenterOfMassUnifiedTurnPhase]
}
