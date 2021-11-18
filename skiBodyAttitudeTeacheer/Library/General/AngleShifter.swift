//
// Created by koyanagi on 2021/11/11.
//　180 to -180　の範囲内で角度を変更
// 170 + 20  =  -170  になる

import Foundation

struct AngleShifter {

    // return
    static func handle(currentAngle: Double, shiftAngle: Double)-> Double{
        let shiftedAngle = (currentAngle + shiftAngle)
        switch shiftedAngle{
        case Double.pi...Double.infinity:
            return Double.pi + (shiftedAngle - Double.pi)
        case (Double.infinity * -1)...(-1 * Double.pi):
            return Double.pi + (shiftedAngle + Double.pi)
        default:
            return shiftedAngle
        }
    }
}
