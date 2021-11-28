//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion

public struct MotionAnalyzerManager {
    var delegate: MotionFeedBackerDelegate =
            MotionFeedBackerImpl.init()
    var unifiedAnalyzedTurnCollection: [OneTurn] = []
    // motion from board
    // motion from headphone
    // 全部混ぜて評価
    var ariPodMotionReceiver: AirPodOnHeadMotionReceiver?
    var boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
            = Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.init()
    public var 磁北偏差 :Double? = nil
    
    public static var shared = MotionAnalyzerManager()
    
    fileprivate init() {
    }

    mutating func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> SkiTurnPhase{
        let now = CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime)
        let va  = boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                                                                now)
        return va
    }

    mutating func receiveAirPodMotion(_ motion: CMDeviceMotion, _
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

    mutating func unify() {
        // 最初のターンマックスは捨てる？
        // ターンマックスごとに切るか
        // 呼び出されたときにスコアを
        // 1ターンごとに
        // ターンごとに
        if boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.turnPhases.count < 10 {
            return
        }
        let skiTurnEnd: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.turnPhases.filterTurnEnd()
        let skiTurnInitiation: [SkiTurnPhase] =
                boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
                        .turnPhases.filterTurnInitialize()
        boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
                .turnPhases = []
        let (skiTurnEndFirst,skiTurnEndLast) = skiTurnEnd.firstAndLastTimeStamp()
        let (skiTurnInitiationFirst,skiTurnInitiationLast) = skiTurnInitiation.firstAndLastTimeStamp()
        let ti: [UnifiedTurnPhase] =
                ariPodMotionReceiver?.turnPhases.filterByTimeStamp(
                        startedAt: skiTurnInitiationFirst,
                        endAt: skiTurnInitiationLast).unifyWithSkiTurnPhases(skiTurnPhases: skiTurnInitiation) ?? []
        let te: [UnifiedTurnPhase] =
                ariPodMotionReceiver?
                .turnPhases
                .filterByTimeStamp(
                        startedAt: skiTurnEndFirst,
                        endAt: skiTurnEndLast)
                .unifyWithSkiTurnPhases(skiTurnPhases: skiTurnEnd) ?? []
        ariPodMotionReceiver?
                .turnPhases = []
        unifiedAnalyzedTurnCollection.append(
                OneTurn.init(oneUnifiedTurnInitiation: ti, oneUnifiedTurnEnd: te)
        )
//         ここに来るのはどうも気に入らない　イベント駆動にするしかなさそうだなぁ　まあしたところで何が変わるかわからんが。
        tellTheScore(score: Int(ScoreOfCenterOfMassMoveToOrthogonalDirectionAgainstFallLineInTurnInitiation.init(
                skiTurnPhaseTurnSwitchToTurnMax: skiTurnInitiation,
                skiTurnPhaseTurnMaxToTurnSwitch: skiTurnEnd,
                centerOfMassTurnPhaseTurnSwitchToTurnMax: te,
                centerOfMassTurnPhaseTurnMaxToTurnSwitch: ti).score())
        )
        tellTheScore(score: 1)
    }
}

