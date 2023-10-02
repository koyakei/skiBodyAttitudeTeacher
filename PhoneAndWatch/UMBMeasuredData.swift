//
//  RiderDataForWatch.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/23.
//

import Foundation
import simd
import Spatial

extension Point3D {
    var realDistanceX: Measurement<UnitLength> {
        get{
            Measurement(value: self.x, unit: .meters)
        }
    }
    
    var realDistanceY: Measurement<UnitLength> {
        get{
            Measurement(value: self.y, unit: .meters)
        }
    }
    
    var realDistanceZ: Measurement<UnitLength> {
        get{
            Measurement(value: self.z, unit: .meters)
        }
    }
    
    var realPoint3DByCentimeter: String {
        get{
            return "\(cmcv(distance: self.realDistanceX)),\(cmcv(distance: self.realDistanceY)),\(cmcv(distance: self.realDistanceZ))"
        }
    }
    
    func cmcv(distance: Measurement<UnitLength>) ->Int{
        let d = distance.converted(to: .centimeters).value
        guard !(d.isNaN || d.isInfinite) else {
            return Int(0) // or do some error handling
        }
        return Int(round(distance.converted(to: .centimeters).value))
       
        
    }
}


struct UMBMeasuredData{
    let distance: Measurement<UnitLength>
    let direction: Vector3D
    let timeStamp: TimeInterval
    var realDistance: Point3D {
        get{
            return Point3D(direction.uniformlyScaled(by: distance.value))
        }
    }
    
    init(distance: Float, direction: SIMD3<Float>) {
        self.direction = Vector3D(direction)
//        Vector3D(x: -1 * Vector3D(direction).x, y: Vector3D(direction).y, z: -1 *  Vector3D(direction).z)
        self.timeStamp = Date.now.timeIntervalSince1970
        self.distance = Measurement(value: Double(distance), unit: .meters)
    }
    
    func radToInt(radian: Double)-> String{
        String(Int(round(Measurement(value: radian, unit: UnitAngle.radians).converted(to: UnitAngle.degrees).value)))
    }
}
