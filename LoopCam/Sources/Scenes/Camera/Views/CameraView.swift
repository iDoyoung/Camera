import SwiftUI
import CoreMotion
import AVKit

struct CameraView<CameraModel: Camera>: View {
    
    typealias AspectRatio = CGSize
    
    @State var camera: CameraModel
    
    var body: some View {
        ZStack(alignment: .bottom) {
            CameraPreview(source: camera.previewSource)
                .aspectRatio(AspectRatio(width: 9, height: 16), contentMode: .fit)
                .onCameraCaptureEvent { event in
                    
                }
                .frame(maxWidth: .infinity)
                .debugBorder()
            
            CameraUI(camera: camera)
                .debugBorder(.blue)
        }
        .padding(.bottom)
    }
}

#Preview {
    CameraView(camera: CameraModel())
}
