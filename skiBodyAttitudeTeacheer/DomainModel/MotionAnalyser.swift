//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion

final public class MotionAnalyzerManager {
    var delegate: MotionFeedBackerDelegate =
            MotionFeedBackerImpl.init()
    var unifiedAnalyzedTurnCollection: [OneTurn] = []
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
    receivedProcessUptime: TimeInterval) -> TurnYawingSide{
        return boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime))
    }

    func receiveAirPodMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) {
        ariPodMotionReceiver.receiver(motion,
                                      CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime))
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

