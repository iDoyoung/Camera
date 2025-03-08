import SwiftUI

struct SwitchCameraButton<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    var deviceOrientation: DeviceOrientation
    
    private let size: CGFloat = 50
    
    var body: some View {
        ZStack {
            Circle()
                .fill(.black.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: size)
            
            Button {
                camera.switchCamera()
            } label: {
                Image(systemName: "arrow.triangle.2.circlepath")
                    .font(.system(size: size/2))
                    .rotationEffect(rotationAngle(for: deviceOrientation))
                    .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            }
            .buttonStyle(SwitchCameraButtonStyle())
        }
    }
    
    struct SwitchCameraButtonStyle: ButtonStyle {
       
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }
    
    private func rotationAngle(for orientation: DeviceOrientation) -> Angle {
        switch orientation {
        case .portrait: return Angle.degrees(0)
        case .landscapeLeft: return Angle.degrees(90)
        case .landscapeRight: return Angle.degrees(-90)
        }
    }
}
