//
//  OneTrun.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/30.
//

import Foundation

// ロールのベースが0 度で
struct FirstOneNotFinishedTurn{
    let turnPhases : [TrunPhase]
    var turnMax: TrunPhase? = nil
    // 正方向のロール角増加がターン前半だとする
    let turnDirection: Int = +1
    var rollBaseAngle = 0
    // 前のターンの最大ロール角はわかっている。
    // 次のターンの最大ロール角を見つける
    // ターン方向よりも逆方向にある区間連続して下がっていれば、ターンマックスを超えたとする
    // 連続した地点
    // それで下がっていって、前のターン最大とあとの最大のちょうど中間
    func turnMaxPassed() -> Bool{
        !( 小さなフェイズごとに単調増加しているか() // してる
        && 離れた二点の増加()) // 離れた二点でもぞうかしてる
        
    }
    
    // 7割単調増加してるか判定
    private func 小さなフェイズごとに単調増加しているか() -> Bool{
        var proCon : Int = 0
        if (downOrUp(startFrame: 9, endFrame: 10)){
            proCon += 1
        }
        if (downOrUp(startFrame: 8, endFrame: 7)){
            proCon += 1
        }
        if (downOrUp(startFrame: 6, endFrame: 5)){
            proCon += 1
        }
        if (downOrUp(startFrame: 5, endFrame: 4)){
            proCon += 1
        }
        if (downOrUp(startFrame: 4, endFrame: 3)){
            proCon += 1
        }
        if (downOrUp(startFrame: 3, endFrame: 2)){
            proCon += 1
        }
        if (downOrUp(startFrame: 2, endFrame: 1)){
            proCon += 1
        }
        return proCon >= 7
    }
    
    // 離れた二点の増加　最初と最後にするか。
    private func 離れた二点の増加() -> Bool{
        downOrUp(startFrame: 0, endFrame: 10)
    }
    
    private func downOrUp(startFrame: Int, endFrame : Int) -> Bool{
        turnDirection.signum() ==
        (
            // 最後からいくつを取る
            turnPhases[-1 *  startFrame].attitude.roll - turnPhases[-1 *  endFrame].attitude.roll
        ).bitPattern.signum()
    }
}

struct OneNotFinishedTurn{
    var turnPhases : [TrunPhase]
    var turnMaxPassed: Bool
    var turnMax: TrunPhase
    // 正方向のロール角増加がターン前半だとする
    var turnDirection = +1
    
    // 前のターンの最大ロール角はわかっている。
    // 次のターンの最大ロール角を見つける
    // ロール角5フレーム前よりも逆方向に下がっていれば、ターンマックスを超えたとする
    // それで下がっていって、前のターン最大とあとの最大のちょうど中間
    func turnMaxFinder()-> TrunPhase{
        beforeOneTrun - afterTrunMax
    }
}

struct OneFinisedTurn{
    let trunPhases : [EvaluatedTrunPhase]
    func turnMaxRollAttitude(_ turnPhases:[TrunPhase]) -> TrunPhase{
        turnPhases.max{$0.attitude.roll < $1.attitude.roll}!
    }
}

struct Doc

struct PairOfFinishedTurn{
    
    let oldTrunPhases:OneFinisedTurn
    let newTurnPhases:OneFinisedTurn
    // 地面に近い方に回り込むように設定する必要がある。
    func rollBace(oldTurnMMax: Double, nextTurnMax: Double) -> Double{
        (oldTurnMMax - nextTurnMax) / 2
    }
    
    func absoluteFalllineAttitude()-> TrunPhase.Attitude{
        return TrunPhase.Attitude.init(roll: rollBace(oldTurnMMax: turnMaxRollAttitude(oldTrunPhases).attitude.roll,nextTurnMax: newTrunMax.attitude.roll),
                                yaw: newTrunMax.attitude.yaw,
                                pitch: newTrunMax.attitude.pitch)
    }
}
