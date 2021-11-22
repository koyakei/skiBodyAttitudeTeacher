//
// Created by koyanagi on 2021/11/18.
//

import Foundation

struct TurnConditionFinder{
    // 常にフォールライン方向に体を運ぶスピードは最大にしなきゃいけない
    // フォールラインと直角に外側に向かって板と自分の距離が縮まる
    // ロール角が一定以上担った場合に、エッジグリップが高くなるのでそこから
    // スキーと自分の重心を話しながら、次のターン外側へ体を運ぶ
    // ロール角以外で縮めていいタイミングを決定できる要素はないのか？
    // ロール角が小さい以外で判断する材料がほしい
    // ヨーイング角ができるだけ深い内に小さくなって踏み始めたい。
    // できるだけ横方向の減速を遅らせたい。
    // 板がターンマックスで帰ってこない場合はどうなんだ？
    // 板が反ってくるかどうかって判定できるの？
    // スキーと重心の相対加速度がマイナスの場合。
    func スキーを通してフォールラインと直角に重心を運ぶ量() {

    }

    func turnFinishFromMovingPhase(movingPhase: MovingPhase) {

    }

//    func turnPhaseFromInitiation() -> Double {
//
//    }
    // 比較している最中にrotation rate の符号が反転しないことを前提にする
    // そもそも ios自体が一秒間に180度を超える回転に対応していないのだろう。
//    func rotationDirectionChanged(
//            evaluationFrame: Int = 10,
//            ターンと認める偏角秒: Double = 30,
//            movingPhases:[MovingPhase]) -> Bool {
//        // 最後１０個 のヨーイング方向の角速度の平均
//        let radian: Double = (Double.pi / 180) * ターンと認める偏角秒
//        (movingPhases[
//                (movingPhases.count - evaluationFrame)..<(movingPhases.count - 1)
//                ].map {
//            $0.rotationRate.z
//        }.reduce(0, +) / Double(evaluationFrame)) > radian
//    }

    // pitch が最大よりも小さければ、フォールラインよりも切り上がっていると判定する
//    func turnMaxPassedByPitchAttitude(
//            movingPhases:[MovingPhase]) throws -> Bool {
//        if (movingPhases.count > 10) {
//            throw TurnError.tooShortToDetectMaxYawAttitude
//        }
//    }
}
