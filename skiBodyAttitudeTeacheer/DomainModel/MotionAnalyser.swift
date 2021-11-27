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
    var ariPodMotionReceiver: AirPodOnHeadMotionReceiver?
    var boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
            = Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.init()
    var 磁北偏差 :Double? = nil
    
    public static let shared = MotionAnalyzerManager()
    
    fileprivate init() {
    }

    func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> SkiTurnPhase{
        let now = CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime)
        let va  = boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                                                                now)
        return va
    }

    func receiveAirPodMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> CenterOfMassTurnPhase?{
        if 磁北偏差 != nil{
            if ariPodMotionReceiver == nil{
                ariPodMotionReceiver = AirPodOnHeadMotionReceiver.init(磁北偏差: 磁北偏差!)
            }
            return ariPodMotionReceiver!.receiver(motion,
                                          CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime))
        }
        return nil
    }

    private func tellTheScore(score: Int) {
        delegate.result(score: score)
    }

    func unify() {
        // 最初のターンマックスは捨てる？
        // ターンマックスごとに切るか
        let skiTurnEnd: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.turnPhases
        let skiTurnInitiation: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
                        .turnPhases
        let ti: [CenterOfMassUnifiedTurnPhase] =
                ariPodMotionReceiver?.turnPhases.filterByTimeStamp(
                        startedAt: skiTurnInitiation.first!.timeStampSince1970,
                        endAt: skiTurnInitiation.first!.timeStampSince1970).unifyWithSkiTurnPhases(skiTurnPhases: skiTurnInitiation) ?? []
        let te: [CenterOfMassUnifiedTurnPhase] =
                ariPodMotionReceiver?
                .turnPhases
                .filterByTimeStamp(
                        startedAt: skiTurnInitiation.first!.timeStampSince1970,
                        endAt: skiTurnInitiation.first!.timeStampSince1970)
                .unifyWithSkiTurnPhases(skiTurnPhases: skiTurnInitiation) ?? []
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

