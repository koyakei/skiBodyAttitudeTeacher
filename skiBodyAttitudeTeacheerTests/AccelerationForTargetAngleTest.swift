//
//  AccelerationForTargetAngleTest.swift
//  skiBodyAttitudeTeacheerTests
//
//  Created by koyanagi on 2021/11/30.
//

import XCTest
import CoreMotion
@testable import skiBodyAttitudeTeacheer

class AccelerationForTargetAngleTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }
    
    func testGetRelativeAttitude() throws{
        // 左右
        XCTAssertEqual(
            ceil(AccelerationForTargetAngle.getRelativeAttitude(
            userAttitude: Attitude.init(roll: 0,
                                        yaw: PhysicsConstants.degree * 44, pitch: 0),
            targetAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * -1, pitch: 0)).yaw),
                       ceil(
                        Attitude.init(roll: 0, yaw: PhysicsConstants.degree * -45, pitch: 0).yaw
                       )
        )
        
        XCTAssertEqual(
            ceil(AccelerationForTargetAngle.getRelativeAttitude(
            userAttitude: Attitude.init(roll: 0,
                                        yaw: PhysicsConstants.degree * -44, pitch: 0),
            targetAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * 1, pitch: 0)).yaw),
                       ceil(
                        Attitude.init(roll: 0, yaw: PhysicsConstants.degree * 45, pitch: 0).yaw
                       )
        )
    }
    func testGetRelativeAttitudeOver180() throws{
        // 180 超える
        XCTAssertEqual(
            ceil(AccelerationForTargetAngle.getRelativeAttitude(
            userAttitude: Attitude.init(roll: 0,
                                        yaw: PhysicsConstants.degree * 170, pitch: 0),
            targetAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * -40, pitch: 0)).yaw),
                       ceil(
                        Attitude.init(roll: 0, yaw: PhysicsConstants.degree * 150, pitch: 0).yaw
                       )
        )
//
        XCTAssertEqual(
            ceil(AccelerationForTargetAngle.getRelativeAttitude(
            userAttitude: Attitude.init(roll: 0,
                                        yaw: PhysicsConstants.degree * -170, pitch: 0),
            targetAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * 40, pitch: 0)).yaw),
                       ceil(
                        Attitude.init(roll: 0, yaw: PhysicsConstants.degree * -150, pitch: 0).yaw
                       )
        )
    }

    func testExample() throws {
        XCTAssertEqual(
            AccelerationForTargetAngle.getRelativeAttitude(userAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0), targetAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0)).yaw,
                       Attitude.init(roll: 0, yaw: 0, pitch: 0).yaw)
        
//        XCTAssertEqual(AccelerationForTargetAngle.handle(
//            userAcceleration: CMAcceleration.init(
//                x: 0, y: 1, z: 0),
//            userAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0),
//            targetAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0)),
//                       <#T##expression2: Equatable##Equatable#>)
        
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
