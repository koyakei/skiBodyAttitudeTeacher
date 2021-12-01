//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import simd
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
                         currentAttitude: Attitude
    ) -> TurnChronologicalPhase {
        let turnMaxPassedChecker: TurnChronologicalPhaseDefinition = TurnChronologicalPhaseDefinition.init(turnYawingSide: turnSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
        switch turnMaxPassedChecker.handle() {
        case .SwitchToMax:
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





