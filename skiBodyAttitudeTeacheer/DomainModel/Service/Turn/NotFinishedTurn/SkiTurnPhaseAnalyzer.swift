//
//  IdealTurnConditionDetector.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
import CoreMotion

struct SkiTurnPhaseAnalyzer {
    //        : TurnPhaseAnalyzerProtocol {
    var turnPhaseFinder: TurnChronologicalPhaseFinder = TurnChronologicalPhaseFinder.init()
    var turnSideChangingPeriodFinder: TurnSideChangingPeriodFinder =
            TurnSideChangingPeriodFinder.init()
    var yawingRotationRateAverageFinder :YawRotationRateMovingAverageFinder = YawRotationRateMovingAverageFinder.init()
    var absoluteFallLineAttitudeFinder: AbsoluteFallLineAttitudeFinder =
            AbsoluteFallLineAttitudeFinder.init()
    var turnSwitchingDirectionFinder: TurnSwitchingDirectionFinder = TurnSwitchingDirectionFinder.init()
    var rotationAngleFinder: RotationAngleFinder = RotationAngleFinder.init()
    mutating func handle(movingPhase:
            MovingPhase) -> SkiTurnPhase {

        let yawingRate: CMRotationRate = rotationAngleFinder.handle(radianAngle: movingPhase.attitude.yaw,timeStamp: movingPhase.timeStampSince1970)
//        let yawingRate : CMRotationRate = yawingRotationRateAverageFinder.handle(
//            rotationRate: rotationRate, timeStampSince1970: movingPhase.timeStampSince1970, period: 0.05)
        let turnYawingSide: TurnYawingSide = yawingRate.yawingSide
        let turnSwitchingDirection: TurnSwitchingDirection = turnSwitchingDirectionFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let turnSideChangePeriod : TimeInterval = turnSideChangingPeriodFinder.handle(currentTimeStampSince1970: movingPhase.timeStampSince1970, currentYawingSide: turnYawingSide)
        let absoluteFallLineAttitude: Attitude = absoluteFallLineAttitudeFinder.handle(attitude: movingPhase.attitude, timeStampSince1970: movingPhase.timeStampSince1970,yawingPeriod: turnSideChangePeriod)
        //         フォールライン方向の加速度を計算
        //         他の指標も計算していく
        //         フォールラインと直角方向の加速度を計算
        let turnPhase: TurnChronologicalPhase = turnPhaseFinder.handle(currentAttitude: movingPhase.attitude, absoluteFallLineAttitude: absoluteFallLineAttitude,
                               currentTurnYawingSide: turnYawingSide, turnSwitchingDirection: turnSwitchingDirection)
        let fallLineOrthogonalAccelerationAndRelativeAttitude:
                TargetDirectionAccelerationAndRelativeAttitude
                =
                FallLineOrthogonalAccelerationCalculator.handle(absoluteFallLineAttitude: absoluteFallLineAttitude, turnYawingSide: turnYawingSide, userAcceleration: movingPhase.userAcceleration, userAttitude: movingPhase.attitude)

        switch turnPhase{
        case .TurnMax:
            MotionAnalyzerManager.shared.unify()
        default:
            <#code#>
        }
        return SkiTurnPhase.init(turnYawingSide: turnYawingSide,
                          turnSwitchingDirection: turnSwitchingDirection,
                          turnSideChangePeriod: turnSideChangePeriod,
                          absoluteFallLineAttitude: absoluteFallLineAttitude,
                          turnPhase: turnPhase,
                          fallLineOrthogonalAccelerationAndRelativeAttitude: fallLineOrthogonalAccelerationAndRelativeAttitude,
                          timeStampSince1970: movingPhase.timeStampSince1970, rotationRate: yawingRate)

        
    }
}



