//
//  MotionAnalyser.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/28.
//

import Foundation
import CoreMotion
import AudioToolbox

class MotionAnalyzerManager: ObservableObject{
    var ariPodMotionReceiver: AirPodOnHeadMotionReceiver?
    var boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver: Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver
            = Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.init()
    public var 磁北偏差: Double? = nil

    var unifyBodyAndSkiTurn :UnifyBodyAndSkiTurn = UnifyBodyAndSkiTurn.shared

    public static var shared: MotionAnalyzerManager = MotionAnalyzerManager()

    fileprivate init() {
    }
    
    public var turnMaxBeep = false
    public var turn1to3Beep = false
    public var turnSwitch = false
    func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> SkiTurnPhase {
        let va = boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                                                                 Date(timeInterval: motion.timestamp, since: Date.now
                                                                         .addingTimeInterval(receivedProcessUptime * -1)).timeIntervalSince1970)
        unifyBodyAndSkiTurn.receive(turnPhase: va)
        return va
    }

    // インターフェイスにして共通化したい
    func skiTurnMax() {
        if turnMaxBeep {
            beepSoundForTurnPhaseSwitching(hz: 440.0, length: 0.1)
        }
    }
    
    func skiTurn1to3(){
        if turn1to3Beep{
            beepSoundForTurnPhaseSwitching(hz: 440.0, length: 0.1)
        }
    }
    
    private func beepSoundForTurnPhaseSwitching(hz: Float, length: TimeInterval){
        SineWave.shared.hz = hz
                    SineWave.shared.play()
        DispatchQueue.main.asyncAfter(deadline: .now() + length) {
                    SineWave.shared.pause()
                }
    }

    func bodyTurnMax(turnPhase: SkiTurnPhase) {
        UnifyBodyAndSkiTurn.shared.receive(turnPhase: turnPhase)
    }
}
