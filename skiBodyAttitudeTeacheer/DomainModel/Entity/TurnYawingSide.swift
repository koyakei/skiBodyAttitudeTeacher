//
// Created by koyanagi on 2021/11/25.
//

import Foundation

enum TurnYawingSide : String{
    case RightYawing = "Right"
    case LeftYawing = "Left"
    case Straight = "Straight"
}

extension TurnYawingSide {
    func shiftAngle() -> Int{
        switch self {
        case .RightYawing:
            return -90
        case .LeftYawing:
            return 90  // - はこっち
        case .Straight:
            return 90
        }
    }
}
