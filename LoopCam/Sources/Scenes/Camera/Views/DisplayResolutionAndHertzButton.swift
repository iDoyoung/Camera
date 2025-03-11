import SwiftUI

struct DisplayResolutionAndHertzButton<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    var deviceOrientation: DeviceOrientation
   
    enum Hertz: String {
        case twentyFour = "24"
        case thirty = "30"
        case sixty = "60"
    }
    
    var body: some View {
        HStack {
            Button {
                // 가독성 고려해 보기
                Task { @MainActor in
                    await camera.setDisplayResolution((camera.displayResolution == .HD1080p) ? .UHD4K: .HD1080p)
                }
            } label: {
                Text(camera.displayResolution.text)
                    .font(.system(size: 13))
                    .foregroundStyle(camera.displayResolution == .UHD4K ? .yellow : .white)
                    .fontWeight((camera.displayResolution == .UHD4K ? .medium : .regular))
                    .monospacedDigit()
            }
            .debugBorder()
            .rotationEffect(rotationAngle(for: deviceOrientation), anchor: .center)
            .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            .disabled(camera.captureActivity.isRecording)
            
            Text("・")
                .padding(.horizontal, 4)
            
            Button {
                Task { @MainActor in
                    let frameRate = camera.frameRate
                    switch frameRate {
                    case .fps30:
                        await camera.setFrameRate(.fps60)
                    case .fps60:
                        await camera.setFrameRate(.fps30)
                    }
                }
            } label: {
                Text(camera.frameRate.text)
                    .foregroundStyle(.white)
                        .monospacedDigit()
                    .font(.system(size: 13, weight: .regular))
            }
            .debugBorder()
            .rotationEffect(rotationAngle(for: deviceOrientation), anchor: .center)
            .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            .disabled(camera.captureActivity.isRecording)
        }
        .padding(.trailing)
    }
    
    private func rotationAngle(for orientation: DeviceOrientation) -> Angle {
        switch orientation {
        case .portrait: return Angle.degrees(0)
        case .landscapeLeft: return Angle.degrees(90)
        case .landscapeRight: return Angle.degrees(-90)
        }
    }
}
