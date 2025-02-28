import SwiftUI

struct ThumbnailButton: View {
    
    @State var thumbnailImage: UIImage? = nil
    var deviceOrientation: DeviceOrientation
    
    private let width: CGFloat = 50
    
    var body: some View {
        Rectangle()
            .fill(.black)
            .opacity(0.3)
            .aspectRatio(1, contentMode: .fit)
            .cornerRadius(4)
            .frame(width: width)
            .overlay {
                if let thumbnailImage {
                    Image(uiImage: thumbnailImage)
                }
            }
            .rotationEffect(rotationAngle(for: deviceOrientation))
            .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
    }
    
    private func rotationAngle(for orientation: DeviceOrientation) -> Angle {
        switch orientation {
        case .portrait: return Angle.degrees(0)
        case .landscapeLeft: return Angle.degrees(90)
        case .landscapeRight: return Angle.degrees(-90)
        }
    }
}
