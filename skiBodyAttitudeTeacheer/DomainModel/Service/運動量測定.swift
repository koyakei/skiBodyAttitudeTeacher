//
//  運動量測定.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2023/09/25.
//

import Foundation

// 垂直方向にかかる力を計算する
// 内外差に対して
struct MeasureRidersMedicalActivity {
    var verticalForce: Double{ // F = m a
        get{
            ridersMass * verticalAccelerationCenterOfMass
        }
    }
    let ridersMass : Double  = 75000 // gram
    let verticalAccelerationCenterOfMass : Double
}
// 1 ターンとか長い期間出だしていく仮説を表現してみよう
