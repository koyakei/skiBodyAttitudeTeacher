//
//  AccelerationShifterTest.swift
//  skiBodyAttitudeTeacheerTests
//
//  Created by koyanagi on 2021/11/30.
//

import XCTest
import CoreMotion
@testable import skiBodyAttitudeTeacheer

class AccelerationShifterTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() throws {
        //右に１進んでいる右に yaw 1
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 1, y: 0, z: 0), relativeAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * -90, pitch: 0)).handle()), 1)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 1, y: 0, z: 0), relativeAttitude: Attitude.init(roll: 0, yaw: PhysicsConstants.degree * 90, pitch: 0)).handle()), -1)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 1, y: 0, z: 0), relativeAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0)).handle()), 0)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 0, y: 1, z: 0), relativeAttitude: Attitude.init(roll: 0, yaw: 0, pitch: 0)).handle()), 1)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 0, y: 1, z: 0), relativeAttitude: Attitude.init(roll: 0, yaw: .pi, pitch: 0)).handle()), -1)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 0, y: 0, z: 1), relativeAttitude: Attitude.init(roll: 0, yaw: .pi, pitch: 0)).handle()), 0)
        XCTAssertEqual(ceil(AccelerationShifter.init(
            relativeAcceleration: CMAcceleration.init(
                x: 0, y: 0, z: 1), relativeAttitude: Attitude.init(roll: .pi, yaw: 0, pitch: 0)).handle()), 0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
