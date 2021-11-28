//
//  EvaluationResponder.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import AVFoundation
import AudioToolbox

struct EvaluationResponder{
    private let synthesizer = AVSpeechSynthesizer()
         // 再生速度を設定
        var rate: Float = AVSpeechUtteranceMaximumSpeechRate
        var voice = AVSpeechSynthesisVoice(language: NSLocale.preferredLanguages.first)
    
    func handle(score: Int){
//        let myUnit = ToneOutputUnit()
//        myUnit.setFrequency(freq: Double(score * 10))
//        myUnit.setToneVolume(vol: 0.5)
//            myUnit.enableSpeaker()
//            myUnit.setToneTime(t:500)
//        myUnit.stop()

        let utterance = AVSpeechUtterance(string: String(score))
                utterance.rate = rate
                utterance.voice = voice
                synthesizer.speak(utterance)
    }
}
