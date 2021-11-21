//
//  Boardに裏返して進行方向にX軸を向けたPhoneturnReceiver.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/31.
//

import Foundation
import CoreMotion

struct Boardに裏返して進行方向にX軸を向けたPhoneTurnReceiver: MotionStreamReceiver{
    // 一番目のバケツ
    // ターンを切ったバケツ
    var finishedTurns: FinishedTurns = FinishedTurns.init()
    
    init(){
        
    }

    //裏側においたとき ひっくり返す。
    // 裏返し　roll 反転　pitch 反転 yaw 反転
    // roll だけ上下にひっくり返す
    func boardRideingPhoneAttitudeConverter(attitude: Attitude) -> Attitude{
        Attitude.init(roll: (Double.pi - attitude.roll) * -1, yaw: attitude.yaw * -1, pitch: attitude.pitch * -1)
    }
    
    func boardRideingPhoneRotationRateConverter(rotationRate: CMRotationRate) -> CMRotationRate{
        CMRotationRate.init(
            x: rotationRate.x * -1,
            y: rotationRate.y,
            z: rotationRate.z * -1
        )
    }
    
    let turnInitNumberOfTurn = 100
    func バケツの移し替え(_ finishedTurnIndex: Int
    , startedTurnIndex: Int){
        if finishedTurns.finishedTurns.count > turnInitNumberOfTurn{
            let pitchArray = turnPhases.turnPhases.map({$0.attitude.pitch})
            let yawArray = turnPhases.turnPhases.map({$0.attitude.yaw})
            finishedTurns.defaultFallLine = Attitude.init(roll: 0, yaw: yawArray.reduce(0.0){
                return $0 + $1/Double(yawArray.count)
            }, pitch: pitchArray.reduce(0.0){
                return $0 + $1/Double(pitchArray.count)
            })
        }
        finishedTurns.finishedTurns.append(OneFinishedMonoSkiTurn.init(turnPhases: <#T##[SkiTurnPhaseWithFallLineAttitude]#>))
        // 捨てる　バケツの移し替え
        turnPhases.turnPhases.removeSubrange(startedTurnIndex...finishedTurnIndex
        )
    }
    
    @State var turning: Bool = false
    @State var lastTurnSide: TurnYawingSide = true
    
    func receiver( turnPhase: TurnPhase){
        turnPhases.turnPhases.append(TurnPhase.init(turnPhase: turnPhase, attitude:  boardRideingPhoneAttitudeConverter(attitude:turnPhase.attitude), rotationRate: boardRideingPhoneRotationRateConverter(rotationRate: turnPhase.rotationRate)))
            
        let finishedIndex = turnPhases.isTurnFinished()
        if finishedIndex != nil{
            バケツの移し替え(finishedIndex!, startedTurnIndex: 0)
        }
        let isStarted = turnStarted()
        if turning{
            
            // ターンの評価に入る　１ターンごとに区切る
        } else {
        
            let turn : FirstOneNotFinishedTurn = FirstOneNotFinishedTurn.init(turnPhases: turnPhases)
            
            if turn.turnMaxPhase != nil{
                
            } else{
                // wait
            }
        }
    }
}
