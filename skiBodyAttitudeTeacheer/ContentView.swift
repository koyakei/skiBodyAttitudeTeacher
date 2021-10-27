//
//  ContentView.swift
//  skiBodyAttitudeTeacheer
//
//  Created by koyanagi on 2021/10/22.
//

import SwiftUI
import CoreMotion
import SensorKit
let motionWriter = MotionWriter()
let motionWriterHeadPhone = MotionWriter()
let motionWriterWatch = MotionWriter()
let coreMotion = CMMotionManager()
let headphoneMotion = CMHeadphoneMotionManager()
// can only fetch data > 24 hours ago - //https://developer.apple.com/documentation/sensorkit/srfetchrequest
let toSecondsOffset:Double = -1 * 24 * 60 * 60;
let minute:Double = 60;
let hour:Double = minute * 60;
let fromDate = NSDate().addingTimeInterval(toSecondsOffset - 48*hour);
let toDate = NSDate().addingTimeInterval(toSecondsOffset - hour);

var device:SRDevice?;

class SensorKitDelegate: NSObject {
    
}

extension SensorKitDelegate: SRSensorReaderDelegate {
    
    func sensorReaderDidStopRecording(_ reader: SRSensorReader) {
        print("----sensorReaderDidStopRecording");
    }
    func sensorReaderWillStartRecording(_ reader: SRSensorReader) {
        print("----sensorReaderWillStartRecording");
    }
    func sensorReader(_ reader: SRSensorReader, fetching fetchRequest: SRFetchRequest, didFetchResult result: SRFetchResult<AnyObject>) -> Bool {
        print("++++++++++sensorReader fetch");
        print(result.sample)
        return true;
    }
    
    func sensorReader(_ reader: SRSensorReader, didChange authorizationStatus: SRAuthorizationStatus) {
        print("----0000 sensorReader authorizationStatus: ");
    }
    
    func sensorReader(_ reader: SRSensorReader, fetchDevicesDidFailWithError error: Error) {
        print("----00000 sensorReader fetchDevicesDidFailWithError: ");
    }
    func sensorReader(_ reader: SRSensorReader, didFetch devices: [SRDevice]) {
        print("----sensorReader didFetch devices: ");
        device = devices[0]
        print("device ", device)
    }
    func sensorReader(_ reader: SRSensorReader, didCompleteFetch fetchRequest: SRFetchRequest) {
        print("----sensorReader didCompleteFetch: ");
    }
    func sensorReader(_ reader: SRSensorReader, stopRecordingFailedWithError error: Error) {
        print("----sensorReader stopRecordingFailedWithError: ");
    }
    func sensorReader(_ reader: SRSensorReader, startRecordingFailedWithError error: Error) {
        print("----sensorReader startRecordingFailedWithError: ");
    }
    func sensorReader(_ reader: SRSensorReader, fetching fetchRequest: SRFetchRequest, failedWithError error: Error) {
        print("----00000 sensorReader fetching failedWithError: ");
    }
    
}


class SensorKitManager {
    let reader = SRSensorReader(sensor:  .accelerometer)
    let sensorKitDelegate = SensorKitDelegate();
    
    func checkToSetDelegate() {
        if (self.reader.delegate == nil) {
            print("setting delegate")
            self.reader.delegate = self.sensorKitDelegate;
         }
    }
    
    func startRecording() {
        self.checkToSetDelegate();
        self.reader.startRecording();
    }
    
    func stopRecording() {
        self.checkToSetDelegate();
        self.reader.stopRecording();
    }
    
    func request() {
        self.checkToSetDelegate();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        print("from: \(dateFormatter.string(from: fromDate as Date))")

        print("requesting access to sensor kit; authorization status: \(self.reader.authorizationStatus)")
        if (self.reader.authorizationStatus != .authorized) {
            
            SRSensorReader.requestAuthorization(sensors: [.accelerometer] ) {
                (error: Error?) -> Void in
                if let error = error { fatalError( "Sensor authorization failed due to: \(error)" ) }
                self.reader.startRecording()
            }
        } else {
            print("already authorized")
            self.startRecording();
            self.fetchDevices();
        }
    }
    
    func fetchDevices() {
        self.reader.fetchDevices();
        
    }
    
    func fetch() {
        self.checkToSetDelegate();
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let request = SRFetchRequest();
        request.from = fromDate.srAbsoluteTime;
        request.to = toDate.srAbsoluteTime;
//        request.from = SRAbsoluteTime(91400845.26107958);
//        request.to = SRAbsoluteTime(91442042.712850332);
        if let value = device {
            request.device = value;
        } else {
            print("fetching devices")
            self.fetchDevices();
        }
        print("authorizationStatus: \(self.reader.authorizationStatus.rawValue)");
        print("3 from: \(dateFormatter.string(from: NSDate(srAbsoluteTime: request.from) as Date)) to: \(dateFormatter.string(from: NSDate(srAbsoluteTime: request.to) as Date))) device: \(request.device.name)")

        self.reader.fetch(request)
    }
}

let sensorKitManager = SensorKitManager();

struct ContentView: View {
    @ObservedObject var connector = WatchConnector()
    var body: some View {
        VStack{
            Button(action: startRecord) {
                Text("Start")
            }
            Button(action: stopRecord) {
                Text("Stop")
            }
            HStack {
                            Text("\(connector.count)")
                        }
                        Text("\(self.connector.receivedMessage)")
        }
    }

    func startRecord(){
        motionWriter.open(MotionWriter.makeFilePath(fileAlias: "Body"))
        motionWriterHeadPhone.open(MotionWriter.makeFilePath(fileAlias: "HeadPhone"))
        coreMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            motionWriter.write(motion!)
        }
        headphoneMotion.startDeviceMotionUpdates(to: OperationQueue.main) { (motion, error) in
            motionWriterHeadPhone.write(motion!)
        }
//        sensorKitManager.request()
//        sensorKitManager.fetch() // 10ms ごとにフェッチ

    }
    
    func stopRecord(){
        coreMotion.stopDeviceMotionUpdates()
        headphoneMotion.stopDeviceMotionUpdates()
        motionWriter.close()
        motionWriterHeadPhone.close()
        motionWriterWatch.open(MotionWriter.makeFilePath(fileAlias: "Watch"))
        connector.motion.forEach{
            motionWriterWatch.write($0)
        }
        motionWriterWatch.close()
//        sensorKitManager.stopRecording()

    }

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
}
