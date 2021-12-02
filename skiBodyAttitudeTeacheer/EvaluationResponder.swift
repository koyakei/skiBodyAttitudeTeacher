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


        let utterance = AVSpeechUtterance(string: String(score))
                utterance.rate = rate
                utterance.voice = voice
                synthesizer.speak(utterance)
    }
}
