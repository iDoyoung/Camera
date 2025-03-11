import SwiftUI
import CoreMotion

enum DeviceOrientation {
    case portrait
    case landscapeLeft
    case landscapeRight
}

struct CameraUI<CameraModel: Camera>: View {
   
    @State var camera: CameraModel
    @State var deviceOrientation: DeviceOrientation = .portrait
    
    private let motionManager = CMMotionManager()
    private let queue = OperationQueue()
    
    var body: some View {
        ZStack {
            HStack {
                RecordingTimeView(time: camera.captureActivity.currentTime)
                    .offset(y: 20)
                    .rotationEffect(.degrees(90))
                    .opacity(deviceOrientation == .landscapeRight ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
                Spacer()
                
                RecordingTimeView(time: camera.captureActivity.currentTime)
                    .offset(y: 20)
                    .rotationEffect(.degrees(-90))
                    .opacity(deviceOrientation == .landscapeLeft ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            }
            
            VStack {
                ZStack {
                    RecordingTimeView(time: camera.captureActivity.currentTime)
                        .opacity(deviceOrientation == .portrait ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
                    
                    HStack {
                        if camera.captureActivity.isRecording {
                            RecordingStatusView()
                        }
                        Spacer()
                        DisplayResolutionAndHertzButton(camera: camera,
                                                        deviceOrientation: deviceOrientation)
                    }
                }
                .background(.black)
                
                Spacer()
                
                HStack {
                    if camera.captureActivity.isRecording == false {
                        ThumbnailButton(deviceOrientation: deviceOrientation)
                    }
                    Spacer()
                    
                    RecordButton(camera: camera)
                    Spacer()
                    
                    if camera.captureActivity.isRecording == false {
                        SwitchCameraButton(camera: camera, deviceOrientation: deviceOrientation)
                    }
                }
                .padding(.horizontal)
            }
            .onAppear {
                motionManager.deviceMotionUpdateInterval = 0.5
                motionManager.startDeviceMotionUpdates(to: queue) { motion, error in
                    if let motion, camera.captureActivity.isRecording == false {
                        DispatchQueue.main.async {
                            if abs(motion.attitude.roll) > 0.9 {
                                if motion.attitude.roll < 0 {
                                    deviceOrientation = .landscapeLeft
                                } else if motion.attitude.roll > 0 {
                                    deviceOrientation = .landscapeRight
                                }
                            } else {
                                deviceOrientation = .portrait
                            }
                        }
                    }
                }
            }
        }
        .padding(.bottom)
    }
}

#Preview {
    CameraUI(camera: CameraModel())
}
