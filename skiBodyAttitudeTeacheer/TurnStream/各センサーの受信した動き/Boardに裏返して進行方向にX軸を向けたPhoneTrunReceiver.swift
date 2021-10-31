//
//  Boardに裏返して進行方向にX軸を向けたPhoneTrunReceiver.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/31.
//

import Foundation
struct Boardに裏返して進行方向にX軸を向けたPhoneTrunReceiver{
    var turnPhases:[TrunPhase]
    
    private func ターンの蓄積がある()-> Bool{
        turnPhases.count > 1000
    }
    
    mutating func receiver( turunPhase: TrunPhase){
        turnPhases.append(turunPhase)
        if ターンの蓄積がある(){
            // ターンの評価に入る　１ターンごとに区切る
        } else {
        
            let turn : FirstOneNotFinishedTurn = FirstOneNotFinishedTurn.init(turnPhases: turnPhases)
            
            if turn.turnMaxPassed(){
                
            } else{
                // wait
            }
        }
    }
}
