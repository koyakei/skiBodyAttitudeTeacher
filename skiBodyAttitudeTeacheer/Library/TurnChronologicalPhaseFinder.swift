//
// Created by koyanagi on 2021/11/18.
//

import Foundation
import simd
import SceneKit

enum TurnPhase {
    case Turn(turnChronologicalPhase: TurnPhaseByStartMaxEnd)
    case Straight
    case Stop
    case TurnSwitch(switchingDirection: TurnSwitchingDirection)
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



extension Array where Element == TurnYawingSide{
    func isRightYawingContinued() -> Bool{
        !self.contains(TurnYawingSide.LeftYawing)
    }
    func isLeftYawingContinued() -> Bool{
        !self.contains(TurnYawingSide.RightYawing)
    }
    // 前の3フレーム連続で同じターン
    func isTurnSideSwitched() -> Bool{
        if (self.count > 5  && self.contains(where:{ $0 != self.last})){
            return true
        }
        return false
    }
}

enum TurnPhaseByStartMaxEnd  : String{
    case SwitchToMax = "SwitchToMax"
    case TurnMax = "TurnMax"
    case MaxToSwitch = "MaxToSwitch"
}


struct FindTurnPhaseBy100{
    func handle(currentRotationEullerAngleFromTurnSwitching: Float,
                oneTurnDiffrentialAngle: Float)-> Double{
        let percent = Double(abs(Double(currentRotationEullerAngleFromTurnSwitching)) / abs(Double(oneTurnDiffrentialAngle)))
        if percent > 1 {
            return 1.0
        } else if percent < 0 {
            return Double.zero
        } else {
            return percent
        }
    }
}

struct CurrentDiffrentialFinder{
    func handle(lastTurnSwitchAngle: simd_quatf, currentQuaternion: simd_quatf) -> Float{
        return abs(QuaternionToEullerAngleDifferential.handle(base: lastTurnSwitchAngle, target: currentQuaternion).z)
    }
}

struct OneTurnDiffrentialFinder {
    var lastTurnSwitchAngle: simd_quatf = simd_quatf.init()
    var oneTurnDiffrentialEuller: Float = Float(Measurement(value: 45.0, unit: UnitAngle.degrees)
        .converted(to: .radians).value)
    
    mutating func handle(isTurnSwitched: Bool ,currentTurnSwitchAngle: simd_quatf) -> Float{
        if (isTurnSwitched){
            oneTurnDiffrentialEuller = abs(QuaternionToEullerAngleDifferential.handle(base: lastTurnSwitchAngle, target: currentTurnSwitchAngle).z)
            lastTurnSwitchAngle = currentTurnSwitchAngle
        }
        return oneTurnDiffrentialEuller
    }
}
