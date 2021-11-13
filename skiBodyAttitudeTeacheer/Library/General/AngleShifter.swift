//
// Created by koyanagi on 2021/11/11.
//

import Foundation

struct AngleShifter {

    // return 180 to -180
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
