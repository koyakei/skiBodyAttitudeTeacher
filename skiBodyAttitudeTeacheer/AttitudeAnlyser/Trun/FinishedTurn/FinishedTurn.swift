//
//  Oneturn.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/30.
//

import Foundation

// ロールのベースが0 度で
struct FirstOneNotFinishedTurn{
    let turnPhases : [TurnPhase]
    var turnMaxPhase: TurnPhase? = nil
    // 正方向のロール角増加がターン前半だとする
    let turnDirection: Int = 1
    var rollBaseAngle = 0
    // 前のターンの最大ロール角はわかっている。
    // 次のターンの最大ロール角を見つける
    // ターン方向よりも逆方向にある区間連続して下がっていれば、ターンマックスを超えたとする
    // 連続した地点
    // それで下がっていって、前のターン最大とあとの最大のちょうど中間
    func turnMaxPassed() {
        if ( // 小さなフェイズごとに単調増加しなくて、離れた二点でも単調増加しなくなった場合
        !小さなフェイズごとに単調増加しているか()
              && !離れた二点の増加()){
            // ターンマックスを
            turnMaxPhase = turnPhases.max(by: <#T##(turnPhase, turnPhase) throws -> Bool#>)
        }
        
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






