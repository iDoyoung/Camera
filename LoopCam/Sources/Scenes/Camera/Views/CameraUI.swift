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
                RecordingTimeView(time: .init())
                    .offset(y: 20)
                    .rotationEffect(.degrees(90))
                    .opacity(deviceOrientation == .landscapeRight ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
                Spacer()
                
                RecordingTimeView(time: .init())
                    .offset(y: 20)
                    .rotationEffect(.degrees(-90))
                    .opacity(deviceOrientation == .landscapeLeft ? 1 : 0)
                    .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            }
            
            VStack {
                ZStack {
                    RecordingTimeView(time: .init())
                        .opacity(deviceOrientation == .portrait ? 1 : 0)
                        .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
                    
                    HStack {
                        RecordingStatusView(camera: camera)
                        Spacer()
                        DisplayResolutionAndHertzButton(camera: camera, deviceOrientation: deviceOrientation)
                    }
                }
                .background(.black)
                
                Spacer()
                
                HStack {
                    ThumbnailButton(deviceOrientation: deviceOrientation)
                    Spacer()
                    
                    RecordButton(camera: camera)
                    Spacer()
                    
                    SwitchCameraButton(camera: camera, deviceOrientation: deviceOrientation)
                }
                .padding(.horizontal)
            }
            .onAppear {
                motionManager.deviceMotionUpdateInterval = 0.5
                motionManager.startDeviceMotionUpdates(to: queue) { motion, error in
                    if let motion {
                        // 방향 판단 로직
                        // 절대값이 임계값보다 큰 경우 방향 변화로 간주
                        DispatchQueue.main.async {
                            if abs(motion.attitude.roll) > 0.9 {
                                if motion.attitude.roll < 0 {
                                    deviceOrientation = .landscapeLeft
                                    print(motion.attitude.roll)
                                } else if motion.attitude.roll > 0 {
                                    deviceOrientation = .landscapeRight
                                }
                            } else {
                                // 임계값보다 작으면 portrait 모드로 판단
                                print("???")
                                deviceOrientation = .portrait
                            }
                        }
                    }
                }
            }
        }
    }
    
//    private func rotationAngle(for orientation: DeviceOrientation) -> Angle {
//        switch orientation {
//        case .portrait: return Angle.degrees(0)
//        case .landscapeLeft: return Angle.degrees(90)
//        case .landscapeRight: return Angle.degrees(-90)
//        }
//    }
}

#Preview {
    CameraUI(camera: CameraModel())
}
