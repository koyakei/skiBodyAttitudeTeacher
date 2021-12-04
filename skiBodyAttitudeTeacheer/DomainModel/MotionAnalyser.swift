//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import AudioToolbox

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
    public var 磁北偏差: Double? = nil

    var unifyBodyAndSkiTurn :UnifyBodyAndSkiTurn = UnifyBodyAndSkiTurn.shared

    public static var shared: MotionAnalyzerManager = MotionAnalyzerManager()

    fileprivate init() {
    }

    mutating func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> SkiTurnPhase {
        let now = CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime)
        let va = boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                                                                 now)
        unifyBodyAndSkiTurn.receive(turnPhase: va)
        return va
    }

    mutating func receiveAirPodMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> CenterOfMassTurnPhase? {
//        if 磁北偏差 != nil {
//            if ariPodMotionReceiver == nil {
//                ariPodMotionReceiver = AirPodOnHeadMotionReceiver.init(磁北偏差: 磁北偏差!)
//            }
//            let va = ariPodMotionReceiver!.receiver(motion,
//                                                    CurrentTimeCalculatorFromSystemUpTimeAndSystemBootedTime.handle(timeStamp: motion.timestamp, systemUptime: receivedProcessUptime))
//            unifyBodyAndSkiTurn.receive(turnPhase: va)
//            return va
//        }
        return nil
    }

    private func tellTheScore(score: Int) {
        delegate.result(score: score)
    }

    // インターフェイスにして共通化したい
    func skiTurnMax() {
//        getScore()
//        var soundIdRing:SystemSoundID = 1000
//            if let soundUrl = CFBundleCopyResourceURL(CFBundleGetMainBundle(), nil, nil, nil){
//                AudioServicesCreateSystemSoundID(soundUrl, &soundIdRing)
//                AudioServicesPlaySystemSound(soundIdRing)
//            }
        
        SineWave.shared.hz = Float(440)
                    SineWave.shared.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                    SineWave.shared.pause()
                }
    }

    func skiTurnSwitch(turnPhase: SkiTurnPhase) {

    }

    func bodyTurnMax(turnPhase: SkiTurnPhase) {
        UnifyBodyAndSkiTurn.shared.receive(turnPhase: turnPhase)
    }

    func bodyTurnSwitch() {

    }

    func getScore() {
        let v = UnifyBodyAndSkiTurn.shared.ac()
//        let v = CurrentVelocity.turnVelocity(
//                movingPhases: TurnPhaseCutter.shared.getOneTurn()
//        )
        let va = Int(v.0 * 36000)
        if va > 1 || va < -1{
        tellTheScore(score: va)
        }
    }
}

