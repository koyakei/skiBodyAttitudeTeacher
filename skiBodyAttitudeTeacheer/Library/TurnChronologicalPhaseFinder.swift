//
// Created by koyanagi on 2021/11/18.
//

import Foundation

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

enum TurnSwitchingDirection {
    case RightToLeft
    case LeftToRight
    case StraightToLeftTurn
    case StraightToRightTurn
    case LeftTurnToStraight
    case RightTurnToStraight
    case Keep
}

enum TurnYawingSide : String{
    case RightYawing = "Right"
    case LeftYawing = "Left"
    case Straight = "Straight"
}

enum TurnChronologicalPhase {
    case SwitchToMax
    case TurnMax
    case MaxToSwitch
}

// ターンマックスだけを見つける
struct TurnChronologicalPhaseDefinition {
    let turnYawingSide: TurnYawingSide
    let absoluteFallLineAttitude: Attitude
    let currentAttitude: Attitude

    func 右ターンの時にターンマックスを過ぎているか() -> TurnChronologicalPhase {
        if turnMax() {
            return TurnChronologicalPhase.TurnMax
        } else if (turnYawingSide == TurnYawingSide.RightYawing && currentAttitude.yaw >
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.MaxToSwitch
        } else if (turnYawingSide == TurnYawingSide.RightYawing && currentAttitude.yaw <
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.SwitchToMax
        }
    }

    func 左ターンの時にターンマックスを過ぎているか() -> TurnChronologicalPhase {
        if turnMax() {
            return TurnChronologicalPhase.TurnMax
        } else if (turnYawingSide == TurnYawingSide.LeftYawing && currentAttitude.yaw <
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.MaxToSwitch
        } else if (turnYawingSide == TurnYawingSide.LeftYawing && currentAttitude.yaw >
                absoluteFallLineAttitude.yaw) {
            return TurnChronologicalPhase.SwitchToMax
        }
    }

    func turnMax() -> Bool {
        // TODO: ここ設定ファイルに出していいかも
        .zero..<PhysicsConstants.degree * 1 ~= abs(currentAttitude.yaw -
                                                           absoluteFallLineAttitude.yaw)
    }

    // ターンマックス前なら false ターンマックス後ならtrue を返す
    // TODO: 右ターンの時にターンマックスを過ぎているかをこのクラスに入れるほうがいいと思うう
    func handle() -> TurnChronologicalPhase {
        // ヨーイング方向によって　以前の角度と今の角度を比較する
        // 以前の角度からのフォールラインのまたぎ越しを判定する
        if turnYawingSide == TurnYawingSide.RightYawing {
            return 右ターンの時にターンマックスを過ぎているか()
        } else if turnYawingSide == TurnYawingSide.LeftYawing {
            return 左ターンの時にターンマックスを過ぎているか()
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
        case TurnChronologicalPhase.SwitchToMax:
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
        // switch 後ずっと　keep しているんだったら　右ターン左ターンでのターンマックスの判断が可能
        if (switch後ずっとKeepか.handle(now: turnSwitchingDirection)) {
            switch (turnSwitchingDirection) {
            case (.RightToLeft):
                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
                switch後ずっとKeepか = Switch後ずっとKeepか.init()
                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
            case (.LeftToRight):
                turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
                switch後ずっとKeepか = Switch後ずっとKeepか.init()
                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
            case (.Keep):
                // 以前の状態を維持していて　 なおかつ左
                // RightToLeft or LeftToRight
                // で他の
                return turnInitiationOrEndDiscriminator.handle(turnSide: currentTurnYawingSide, absoluteFallLineAttitude: absoluteFallLineAttitude, currentAttitude: currentAttitude)
            default:
                return TurnChronologicalPhase.TurnMax
            }
        } else {
            /// キープが崩れたら turn max finder を　最初期化
            turnInitiationOrEndDiscriminator = TurnInitiationOrEndDiscriminator.init()
            switch後ずっとKeepか = Switch後ずっとKeepか.init()
            // ホントはここで ターンマックスを返すんじゃなくてエラーをはくほうがいいのか
            return TurnChronologicalPhase.TurnMax
        }
    }
}





