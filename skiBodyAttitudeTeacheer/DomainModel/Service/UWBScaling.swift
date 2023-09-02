//
//  UWBScaling.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/01.
//

import Foundation
import simd
import NearbyInteraction
import SceneKit
import Spatial
struct UMBScaling {
    
    let forwardFloat3 : simd_quatf = simd_quatf(Rotation3D())
    let n = SCNNode()
    // 前との角度差を計測 degreeでかえす
    func yawDiff(hipDir: simd_quatf) -> Float{
        n.simdOrientation = simd_normalize(hipDir * forwardFloat3.inverse)
        return Float(abs(Measurement(value: Double(n.eulerAngles.z), unit: UnitAngle.radians)
            .converted(to: .degrees).value))
    }
}

struct UMBDirDistance{
    let dir: simd_float3
    let distance: Float
    let timeStamp: TimeInterval
}

struct hipOrientation{
    let rightHip: UMBDirDistance
    let leftHip: UMBDirDistance
    
    func yawDegreeDiffrencial() -> Double {
        let diff = handle() - Vector3D.forward
        return Angle2D(radians: atan2(diff.x,diff.y)).degrees
    }
    // 右腰と左腰の位置がわかる　それを結んだ線のヨーイング方向にを出力する
    func handle()-> Vector3D {
        (Vector3D.init(rightHip.dir).uniformlyScaled(by: Double(rightHip.distance)) - Vector3D.init(leftHip.dir).uniformlyScaled(by: Double(leftHip.distance))).rotated(by: Rotation3D.init(angle: Angle2D(degrees: 90), axis: RotationAxis3D.z)).normalized
    }
}
