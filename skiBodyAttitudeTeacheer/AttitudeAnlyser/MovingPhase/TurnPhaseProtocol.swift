//
// Created by koyanagi on 2021/11/05.
//

import Foundation

protocol TurnPhaseYawSimpleRotationRateAverageProtocol: MovingPhaseProtocol {
    var rotationRateAverage: Double { get }
    var fallLineAcceleration: Double { get }
    var fallLineOrthogonalAcceleration: Double { get }
    var fallLineOrthogonalRelativeAttitude: Attitude { get }
}

protocol TurnPhaseWithRotationRateXDirectionProtocol:
        TurnPhaseYawSimpleRotationRateAverageProtocol {
    var rotationRateXDirection: TurnSide { get }
    var turnSideChanged: Bool { get }
    var rotationRateDirectionChangePeriod: MilliSecond { get }
}


