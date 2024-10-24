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
    let motionFeedBackerImpl : MotionFeedBackerImpl = MotionFeedBackerImpl()
    
    fileprivate init() {
    }
    
    public var turnMaxBeep = false
    public var turn1to3Beep = false
    public var isターン前半のタメ音声通知 = false
    public var isターン切替時の減衰率の音声通知 = false
    var currentVelocity = CurrentVelocity.init(initalSpeed: 0)
    var beforeTimeStamp: TimeInterval = Date.now.timeIntervalSince1970
    func receiveBoardMotion(_ motion: CMDeviceMotion, _
    receivedProcessUptime: TimeInterval) -> SkiTurnPhase {
        let va = boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver.receiver(motion,
                                                                 Date(timeInterval: motion.timestamp, since: Date.now
                                                                         .addingTimeInterval(receivedProcessUptime * -1)).timeIntervalSince1970)
        unifyBodyAndSkiTurn.receive(turnPhase: va)
        return va
    }
    
    func xArbitraryMotion(_ motion: CMDeviceMotion, _
                          receivedProcessUptime: TimeInterval) -> Double{
        let sysTime = Date(timeInterval: motion.timestamp, since: Date.now
                .addingTimeInterval(receivedProcessUptime * -1)).timeIntervalSince1970
        let currentV = currentVelocity.handle(currentAcceleration: motion.userAcceleration.y, currentiTimestamp: sysTime, beforeMovingPhaseTimeStamp: beforeTimeStamp)
        beforeTimeStamp = sysTime
        return currentV
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
    
    func ターン前半のタメ音声通知(diffrencialRatio: Double){
        if isターン前半のタメ音声通知{
            motionFeedBackerImpl.result(score: Int(diffrencialRatio * 100))
        }
    }
    
    func ターン切替時の減衰率の音声通知(diffrencialRatio: Double){
        if isターン切替時の減衰率の音声通知{
            motionFeedBackerImpl.result(score: Int(diffrencialRatio * 100))
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
