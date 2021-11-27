//
// Created by koyanagi on 2021/11/25.
//

import Foundation

struct FallLineOutSideOrthogonalDirectionFinder{
    static func handle(fallLineAttitude: Attitude, turnYawingSide: TurnYawingSide)-> Attitude{
        switch turnYawingSide{
        case .RightYawing:
            return Attitude.init(roll: 0, yaw: fallLineAttitude.yaw  - ( Double.pi / 2) , pitch: 0)
        case .LeftYawing:
            return Attitude.init(roll: 0, yaw: fallLineAttitude.yaw  - (Double.pi / -2), pitch: 0)
        case .Straight:
            return fallLineAttitude
        }
    }
}
