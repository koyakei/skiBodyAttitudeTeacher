//
//  QuaternionToEullerAngleDiffrencial.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2022/06/09.
//

import Foundation
import SpriteKit
import SceneKit

struct QuaternionToEullerAngleDifferential{
    static func handle(base : simd_quatf, target: simd_quatf) -> SCNVector3{
        return convertToEuller(simdq: simd_normalize( target * base.inverse))
    }
    
    static func convertToEuller(simdq: simd_quatf) -> SCNVector3{
        let n = SCNNode()
        n.simdOrientation = simdq
        return n.eulerAngles
    }
    
}
