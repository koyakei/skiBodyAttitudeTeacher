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
    
    public var turnMaxBeep = false
    public var 内倒警告 = false
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
//        if 磁北偏差 != nil {w
        return nil
    }

    private func tellTheScore(score: Int) {
        delegate.result(score: score)
    }

    // インターフェイスにして共通化したい
    func skiTurnMax() {
//        getScore()
        if turnMaxBeep {
            turnMaxBeepSound()
        }
    }
    
    private func turnMaxBeepSound(){
        SineWave.shared.hz = Float(440)
                    SineWave.shared.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    SineWave.shared.pause()
                }
    }

    func skiTurnSwitch(turnPhase: SkiTurnPhase) {

    }
    
    func skiTurnMaxToSwitch(turnPhase: SkiTurnPhase) {
        if 内倒警告 && turnPhase.badRollRotationRate &&
            TimingStone.handle(timeIntervalSince1970: turnPhase.timeStampSince1970) {
            turnMaxBeepSound()

        }
    }
    
    func skiTurnSwitchToMax(turnPhase: SkiTurnPhase) {
        
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

struct TimingStone{
    static func handle(timeIntervalSince1970: TimeInterval) -> Bool{
        let date : Date = Date(timeIntervalSince1970: timeIntervalSince1970)
        let calendar : Calendar = NSCalendar.current
        let components : DateComponents = calendar.dateComponents([.nanosecond], from: date)
        let nanoSeconds: Int = components.nanosecond ?? 0
        let millSeconds = Int(nanoSeconds / 100000)
        return millSeconds % 10 == 0
    }
}
