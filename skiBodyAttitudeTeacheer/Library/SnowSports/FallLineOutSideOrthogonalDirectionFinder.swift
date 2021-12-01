//
// Created by koyanagi on 2021/11/25.
//

import Foundation
import simd


struct FallLineOutSideOrthogonalDirectionFinder {
    let fallLineAttitude: simd_quatd
    let turnYawingSide: TurnYawingSide

    // absolute attitude
    func handle() -> simd_quatd {
        switch turnYawingSide {
        case .RightYawing:
            return simd_normalize(fallLineAttitude * yawRotation(-90.0))
        case .LeftYawing:
            return simd_normalize(fallLineAttitude * yawRotation(90.0))
        case .Straight:
            return fallLineAttitude
        }
    }

    private func yawRotation(_ degree: Double) -> simd_quatd {
        simd_quatd(
                angle: Measurement(value: degree, unit: UnitAngle.degrees)
                        .converted(to: .radians).value,
                axis: simd_double3(x: 0, y: 0, z: 1))
    }
}
