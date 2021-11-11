//
// Created by koyanagi on 2021/11/11.
//

import Foundation

struct TurnScoreEvaluator {
    // ローリング角の同調
    // ヨーイング角度の同調
    // 角速度の同調
    // ターンマックスが 180度以上離れていること
    // 各種スコアは毎ターンごとに出すのが良さそうだ。
    // ターン中盤でスコアを出したい場合は、区切りをもっと細かくしなきゃだめだね。
    // 途中でスコアを出さないとね。
    func pivotSlipScore() {

    }

    // ターン後半でのフォールライン方向の加速度の体とスキーの差で表現可能か？
    //
    func outSideTurnScore() {

    }

    // 前後バランススコア
    func forwardAfterwardBalanceScore() {

    }
}
