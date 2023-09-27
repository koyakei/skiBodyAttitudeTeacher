//
//  内倒.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/25.
//

import Foundation
import Spatial
import simd

struct InclineCoM {
    
    // ロール角も含んだフォールラインの設定

    
    let fallLineDirectionGravityAbsoluteByNorth : Rotation3D
    var centerOfMassRelativeDirectionFromSki: Point3D
    var gravityAbsoluteVerticalCenterOfMassDirectionFromSki : Point3D {
        get {
            centerOfMassRelativeDirectionFromSki.rotated(by: diffOfSkiDrectionAndFallLine)
        }
    }
    
    var diffOfSkiDrectionAndFallLine : Rotation3D {
        get {
            fallLineDirectionGravityAbsoluteByNorth.inverse * skiDirectionAbsoluteByNorth
        }
    }
    let ridersMass: Double = 75 * 1000// gram
    let skiDirectionAbsoluteByNorth: Rotation3D
    
    var fallLineForwardGravityAbsoluteCenterOfMass : Point3D {
        get {
            centerOfMassRelativeDirectionFromSki.rotated(by: diffOfSkiDrectionAndFallLine)
        }
    }
    var 谷側に倒れているラジアン角度 :  Double{
        get {
            atan(tan(fallLineForwardGravityAbsoluteCenterOfMass.x / fallLineForwardGravityAbsoluteCenterOfMass.y))
        }
    }
    
    var 谷のどれだけ重心を落とせているか: Double {
        get {
            ridersMass * fallLineForwardGravityAbsoluteCenterOfMass.y
        }
    }
    var sterlingAngle : Double {
        get{
            // ロール角が右と左で処理を分ける
            if diffOfSkiDrectionAndFallLine.eulerAngles(order: .pitchYawRoll).angles.z < 0{
                return diffOfSkiDrectionAndFallLine.eulerAngles(order: .pitchYawRoll).angles.y
            } else {
                return -diffOfSkiDrectionAndFallLine.eulerAngles(order: .pitchYawRoll).angles.y
            }
        }
    }
    
    // ステアリングアングルが大きい状態で谷に重心が落とせていないほど減速する
    // tan かもしれない。　考えよう。
    var 谷に落とすのに失敗していることでどれだけ板がズレて減速したがっているか : Double {
        sin(sterlingAngle) * -谷のどれだけ重心を落とせているか
    }
    
    private func convertU1ResultToDirCoM(direction: SIMD3<Float>) -> Point3D{
        Point3D(x: -direction.x, y: direction.y, z: -direction.z)
    }
}

