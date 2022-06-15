//
// Created by koyanagi on 2021/11/16.
// TODO: 処理の共通化するべき

import Foundation

struct Calc{
    let bodyO: IsMovingDiscriminator
    let bodyF: IsMovingDiscriminator
    let skiO: IsMovingDiscriminator
    let skiF: IsMovingDiscriminator
}
struct Distance{
    let bodyODis: Double
    let bodyFDis: Double
}

struct TurnVelocity{
    let bodyO: Double
    let bodyF: Double
    let skiO: Double
    let skiF: Double
}
