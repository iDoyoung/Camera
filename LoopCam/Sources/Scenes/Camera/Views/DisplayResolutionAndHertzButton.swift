import SwiftUI

struct DisplayResolutionAndHertzButton<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    var deviceOrientation: DeviceOrientation
    
    //Mock
    @State var hertz: Hertz = .sixty
    
    enum Hertz: String {
        case twentyFour = "24"
        case thirty = "30"
        case sixty = "60"
    }
    
    var body: some View {
        HStack {
            Button {
                // 가독성 고려해 보기
                camera.setDisplayResolution((camera.displayResolution == .HD1080p) ? .UHD4K: .HD1080p)
                 
                if camera.displayResolution == .UHD4K,
                   hertz == .twentyFour {
                    hertz = .thirty
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
                switch camera.displayResolution {
                case .UHD4K:
                    // 가독성 고려해 보기
                    hertz = (hertz == .sixty) ? .thirty : .sixty
                default:
                    switch hertz {
                    case .twentyFour:
                        hertz = .thirty
                    case .thirty:
                        hertz = .sixty
                    case .sixty:
                        hertz = .twentyFour
                    }
                }
            } label: {
                Text(hertz.rawValue)
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
