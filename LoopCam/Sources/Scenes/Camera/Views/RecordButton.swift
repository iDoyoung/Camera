import SwiftUI

struct RecordButton<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    @State var isRecording = false
    
    private let buttonSize: CGFloat = 68
    
    var body: some View {
        VideoCaptureButton(
            isRecording: $isRecording) { _ in
                
            }
            .aspectRatio(1.0, contentMode: .fit)
            .frame(width: buttonSize)
    }
}

private struct VideoCaptureButton: View {
    
    @Binding private var isRecording: Bool
    
    private let action: (Bool) -> Void
    private let lineWidth: CGFloat = 3.0
    
    init(isRecording: Binding<Bool>, action: @escaping (Bool) -> Void) {
        _isRecording = isRecording
        self.action = action
    }
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(lineWidth: lineWidth)
                .foregroundColor(Color.white)
            Button {
                withAnimation(.easeInOut(duration: 0.25)) {
                    isRecording.toggle()
                }
                action(isRecording)
            } label: {
                GeometryReader { geometry in
                    RoundedRectangle(cornerRadius: geometry.size.width / (isRecording ? 4.0 : 2.0))
                        .inset(by: lineWidth * 1.2)
                        .fill(Color(red: 1, green: 0, blue: 0))
                        .scaleEffect(isRecording ? 0.6 : 1.0)
                }
            }
            .buttonStyle(VideoCaptureButtonStyle())
        }
    }
    
    struct VideoCaptureButtonStyle: ButtonStyle {
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .sensoryFeedback(.impact, trigger: configuration.isPressed)
                .scaleEffect(configuration.isPressed ? 0.9 : 1.0)
                .animation(.easeInOut(duration: 0.15), value: configuration.isPressed)
        }
    }
}
