//
//  MotionEvaluator.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/11/01.
//

import Foundation
struct MotionFeedBackerImpl: MotionFeedBackerDelegate{
    
   
    func result(score: Int) {
        evaluationResponder.handle(score: score)
    }
    
    let evaluationResponder: EvaluationResponder = EvaluationResponder()
    
}
