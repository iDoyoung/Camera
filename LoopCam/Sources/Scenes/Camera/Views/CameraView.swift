import SwiftUI
import CoreMotion

struct CameraView<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray)
            CameraUI(camera: camera)
                .padding(.bottom)
        }
        .padding(.bottom)
    }
}

#Preview {
    CameraView(camera: CameraModel())
}
