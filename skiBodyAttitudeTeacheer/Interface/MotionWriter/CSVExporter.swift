//
//  MotionWriter.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/24.
//

import Foundation
import CoreMotion

class CSVExporter {
    var file: FileHandle?
    var filePath: URL?
    var sample: Int = 0
    let startAt : Date = Date.now
    
    func getClassName(myInstance : Any) -> String{
        let mirror = Mirror(reflecting: myInstance)
        if let className = mirror.subjectType as? AnyClass {
            let classNameString = String(describing: className)
            return "\(classNameString)"
        } else{
            return "error"
        }
    }
    
    func structNameExpander(structObject: Any) -> String{
        let mirror = Mirror(reflecting: structObject)
        var labels:[String] = []
        for case let (label?, _) in mirror.children {
            labels.append(label)
        }
        return labels.joined(separator: ",")
    }

    func open(structObject: Any) {
        do {
            let filePath = CSVExporter.makeFilePath(fileAlias: getClassName(myInstance: structObject))
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            let file = try FileHandle(forWritingTo: filePath)
            var header = ""
            header += structNameExpander(structObject: structObject)
            header += "\n"
            file.write(header.data(using: .utf8)!)
            self.file = file
            self.filePath = filePath
        } catch let error {
            print(error)
        }
    }

    func write(_ structObject: Any) {
        let mirror = Mirror(reflecting: structObject)
        var values:[String] = []
        for case let (_, value) in mirror.children {
            values.append(value as! String)
        }
        guard let file = self.file else { return }
        var text = ""
        text += values.joined(separator: ",")
        text += "\n"
        file.write(text.data(using: .utf8)!)
        sample += 1
    }

    func close() {
        guard let file = self.file else { return }
        file.closeFile()
        print("\(sample) sample")
        self.file = nil
    }

    static func getDocumentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func makeFilePath(fileAlias: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let filename = formatter.string(from: Date()) + "\(fileAlias).csv"
        let fileUrl = url.appendingPathComponent(filename)
        print(fileUrl.absoluteURL)
        return fileUrl
    }
}
class WatchMotionWriter {

    var file: FileHandle?
    var filePath: URL?
    var sample: Int = 0
    let startAt : Date = Date.now

    func open(_ filePath: URL) {
        do {
            FileManager.default.createFile(atPath: filePath.path, contents: nil, attributes: nil)
            let file = try FileHandle(forWritingTo: filePath)
            var header = ""
            header += "date_now,"
            header += "acceleration_x,"
            header += "acceleration_y,"
            header += "acceleration_z,"
            header += "attitude_pitch,"
            header += "attitude_roll,"
            header += "attitude_yaw,"
//            header += "gravity_x,"
//            header += "gravity_y,"
//            header += "gravity_z,"
//            header += "quaternion_x,"
//            header += "quaternion_y,"
//            header += "quaternion_z,"
//            header += "quaternion_w,"
//            header += "rotation_x,"
//            header += "rotation_y,"
//            header += "rotation_z,"
            header += "time interval"
            header += "\n"
            file.write(header.data(using: .utf8)!)
            self.file = file
            self.filePath = filePath
        } catch let error {
            print(error)
        }
    }

    func write(_ motion: WatchMotion) {
        guard let file = self.file else { return }
        var text = ""
        let format = DateFormatter()
            format.dateFormat = "HH:mm:ss.SSS"
        format.timeZone = .current
        text += "\(format.string(from: Date(timeIntervalSince1970: motion.timestamp))),"
        text += "\(motion.userAcceleration.x),"
        text += "\(motion.userAcceleration.y),"
        text += "\(motion.userAcceleration.z),"
        text += "\(motion.attitude.pitch),"
        text += "\(motion.attitude.roll),"
        text += "\(motion.attitude.yaw),"
//        text += "\(motion.gravity.x),"
//        text += "\(motion.gravity.y),"
//        text += "\(motion.gravity.z),"
//        text += "\(motion.attitude.quaternion.x),"
//        text += "\(motion.attitude.quaternion.y),"
//        text += "\(motion.attitude.quaternion.z),"
//        text += "\(motion.attitude.quaternion.w),"
//        text += "\(motion.rotationRate.x),"
//        text += "\(motion.rotationRate.y),"
//        text += "\(motion.rotationRate.z),"
        text += "\(motion.timestamp)"
        print(text)
        text += "\n"
        file.write(text.data(using: .utf8)!)
        sample += 1
    }

    func close() {
        guard let file = self.file else { return }
        file.closeFile()
        print("\(sample) sample")
        self.file = nil
    }

    static func getDocumentPath() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }

    static func makeFilePath(fileAlias: String) -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let formatter: DateFormatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let filename = formatter.string(from: Date()) + "\(fileAlias).csv"
        let fileUrl = url.appendingPathComponent(filename)
        print(fileUrl.absoluteURL)
        return fileUrl
    }
}

struct WatchMotion{
    let timestamp : TimeInterval
    let userAcceleration: CMAcceleration
    let rotationRate : CMRotationRate
    let attitude: Attitude
    struct Attitude{
        let roll : Double
        let yaw: Double
        let pitch: Double
    }
}
