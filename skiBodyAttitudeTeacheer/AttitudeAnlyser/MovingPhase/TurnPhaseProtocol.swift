//
// Created by koyanagi on 2021/11/05.
//

import Foundation
protocol TurnPhaseProtocol: MovingPhaseProtocol {

}

protocol TurnPhaseYawSimpleRotationRateAverageProtocol: TurnPhaseProtocol{
    var rotationRateAverage: Double{get}
}

protocol TurnPhaseWithRotationRateXDirectionProtocol:
        TurnPhaseYawSimpleRotationRateAverageProtocol{
    var rotationRateXDirection: TurnSide{get}
    var turnSideChanged:Bool{get}
}
// 向きの変化周期
protocol TurnPhaseWithRotationRateXDirectionChangePeriodProtocol: TurnPhaseWithRotationRateXDirectionProtocol{
    var rotationRateDirectionChangePeriod: MilliSecond{get}
}
// ヨーイングの移動平均
protocol TurnPhaseWithAverageYawAngleProtocol:TurnPhaseWithRotationRateXDirectionChangePeriodProtocol{
    var movingAverageYawAngle: Double { get }
}


