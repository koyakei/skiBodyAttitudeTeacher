//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import simd
import SceneKit

enum TurnPhase {
    case Turn(turnChronologicalPhase: TurnChronologicalPhase)
    case Straight
    case Stop
    case TurnSwitch(switchingDirection: TurnSwitchingDirection)
    //    case RightTurnSwitchToTurnMax
    //    case RightTurnMax
    //    case RightTurnMaxToTurnSwitch
    //    case TurnSwitchRightToLeft
    //    case LeftTurnSwitchToTurnMax
    //    case LeftTurnMax
    //    case LeftTurnMaxToTurnSwitch
}

enum TurnSwitchingDirection: String {
    case RightToLeft = "RightToLeft"
    case LeftToRight = "LeftToRight"
    case StraightToLeftTurn = "StraightToLeftTurn"
    case StraightToRightTurn = "StraightToRightTurn"
    case LeftTurnToStraight = "LeftTurnToStraight"
    case RightTurnToStraight = "RightTurnToStraight"
    case Keep = "Keep"
}



extension Collection where Element == TurnYawingSide{
    func isRightYawingContinued() -> Bool{
        !self.contains(TurnYawingSide.LeftYawing)
    }
    func isLeftYawingContinued() -> Bool{
        !self.contains(TurnYawingSide.RightYawing)
    }

}

enum TurnChronologicalPhase  : String{
    case SwitchToMax = "SwitchToMax"
    case TurnMax = "TurnMax"
    case MaxToSwitch = "MaxToSwitch"
    case Turn1to3 = "Turn1to3"
    case Turn3to6 = "Turn3to6"
    case Turn4to6 = "Turn4to6"
    case Turn3to3 = "Turn3to3"
}


// ターンマックスだけを見つける
struct TurnChronologicalPhaseDefinition {
    let turnYawingSide: TurnYawingSide
    let absoluteFallLineAttitude: Attitude
    let currentAttitude: Attitude
    func 右ターンの時にターンマックスを過ぎているか() -> TurnChronologicalPhase {
        if turnMax() {
            return TurnChronologicalPhase.TurnMax
        } else if (turnYawingSide == TurnYawingSide.RightYawing && currentAttitude.yaw <
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.MaxToSwitch
        } else if (turnYawingSide == TurnYawingSide.RightYawing && currentAttitude.yaw >
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.SwitchToMax
        }
        return TurnChronologicalPhase.SwitchToMax
    }

    func 左ターンの時にターンマックスを過ぎているか() -> TurnChronologicalPhase {
        if turnMax() {
            return TurnChronologicalPhase.TurnMax
        } else if (turnYawingSide == TurnYawingSide.LeftYawing && currentAttitude.yaw >
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.MaxToSwitch
        } else if (turnYawingSide == TurnYawingSide.LeftYawing && currentAttitude.yaw <
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.SwitchToMax
        }
        return TurnChronologicalPhase.SwitchToMax
    }

    func turnMax() -> Bool {
        .zero..<PhysicsConstants.degree * 1 ~= abs(
            TwoAngleDifferential.handle(angle: currentAttitude.yaw, secondAngle: absoluteFallLineAttitude.yaw))
    }

    // ターンマックス前なら false ターンマックス後ならtrue を返す
    // TODO: 右ターンの時にターンマックスを過ぎているかをこのクラスに入れるほうがいいと思うう
    func handle() -> TurnChronologicalPhase {
        // ヨーイング方向によって　以前の角度と今の角度を比較する
        // 以前の角度からのフォールラインのまたぎ越しを判定する
        switch turnYawingSide{
        case TurnYawingSide.RightYawing:
            return 右ターンの時にターンマックスを過ぎているか()
        case .LeftYawing:
            return 左ターンの時にターンマックスを過ぎているか()
        case .Straight:
            return TurnChronologicalPhase.SwitchToMax
        }
        
    }
}



struct TurnInitiationOrEndDiscriminator {
    var isTurnMaxPassed: Bool = false
    mutating func handle(turnSide: TurnYawingSide,
                         absoluteFallLineAttitude: Attitude,
                         absoluteFallLineByQuotanion: simd_quatf,
                         currentAttitude: Attitude,
                         currentAttitudeByQuotanion: simd_quatf,
                         lastTurnSwitchAngleQ: simd_quatf
    ) -> TurnChronologicalPhase {
        let turnMaxPassedChecker: TurnChronologicalPhaseDefinition = TurnChronologicalPhaseDefinition.init(turnYawingSide: turnSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
        switch turnMaxPassedChecker.handle() {
        case .SwitchToMax:
            let turn1to3 = (simd_normalize(lastTurnSwitchAngleQ + (2 * absoluteFallLineByQuotanion)))
            let n = SCNNode()
            n.simdOrientation = turn1to3
            if((lastTurnSwitchAngleQ - turn1to3).axis.z < (lastTurnSwitchAngleQ - currentAttitudeByQuotanion).axis.z){
                return TurnChronologicalPhase.Turn1to3
            }
            // 最後のターンマックス - 現在の姿勢 = ターンマックスと現在の姿勢の角度差
            // turn1to3 がターンフェイズの切れ目 最後のターンマックス - ターンフェイズ1/3 = ターンマックスと 1/3 の角度差
                //　ターンマックスと現在の姿勢の角度差 < ターンマックスと 1/3 の角度差
            return TurnChronologicalPhase.SwitchToMax
        case .TurnMax:
            isTurnMaxPassed = true
            return .TurnMax
        case .MaxToSwitch:
            if isTurnMaxPassed {
                return TurnChronologicalPhase.MaxToSwitch
            }
            isTurnMaxPassed = true
            return TurnChronologicalPhase.TurnMax
        case .Turn1to3:
            return TurnChronologicalPhase.TurnMax
        case .Turn3to6:
            return TurnChronologicalPhase.TurnMax
        case .Turn4to6:
            return TurnChronologicalPhase.TurnMax
        case .Turn3to3:
            return TurnChronologicalPhase.TurnMax
        }
    }
}

struct TurnChronologicalPhaseFinder {
    var switch後ずっとKeepか: Switch後ずっとKeepか = Switch後ずっとKeepか.init()
    var turnInitiationOrEndDiscriminator: TurnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
    
    mutating func handle(currentAttitude: Attitude,
                         absoluteFallLineAttitude: Attitude,
                         currentTurnYawingSide: TurnYawingSide,
                         turnSwitchingDirection: TurnSwitchingDirection
    ) -> TurnChronologicalPhase {
        return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
        // switch 後ずっと　keep しているんだったら　右ターン左ターンでのターンマックスの判断が可能
//        if (switch後ずっとKeepか.handle(now: turnSwitchingDirection)) {
//            switch (turnSwitchingDirection) {
//            case (.StraightToLeftTurn):
////                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
//                switch後ずっとKeepか = Switch後ずっとKeepか.init()
//                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
//            case (.StraightToRightTurn):
////                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
//                switch後ずっとKeepか = Switch後ずっとKeepか.init()
//                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
//            case (.Keep):
//                // 以前の状態を維持していて　 なおかつ左
//                // RightToLeft or LeftToRight
//                // で他の
//                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
////            case .LeftTurnToStraight:
////                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
////                switch後ずっとKeepか = Switch後ずっとKeepか.init()
////                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
////            case .RightTurnToStraight:
////                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
////                switch後ずっとKeepか = Switch後ずっとKeepか.init()
////                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
//            default:
//                return TurnChronologicalPhase.MaxToSwitch
//            }
//        } else {
//            /// キープが崩れたら turn max finder を　最初期化
//            turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
//            switch後ずっとKeepか = Switch後ずっとKeepか.init()
//            // ホントはここで ターンマックスを返すんじゃなくてエラーをはくほうがいいのか
//            return TurnChronologicalPhase.TurnMax
//        }
    }
}





