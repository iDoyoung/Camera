import SwiftUI

struct DisplayResolutionAndHertzButton<CameraModel: Camera>: View {
    
    @State var camera: CameraModel
    var deviceOrientation: DeviceOrientation
    
    //Mock
    @State var displayResolution: DisplayResolution = .hd
    @State var hertz: Hertz = .sixty
    
    enum DisplayResolution: String {
        case hd = "HD"
        case uhd = "4k"
    }
    
    enum Hertz: String {
        case twentyFour = "24"
        case thirty = "30"
        case sixty = "60"
    }
    
    var body: some View {
        HStack {
            Button {
                // 가독성 고려해 보기
                displayResolution = (displayResolution == .hd) ? .uhd : .hd
                
                if displayResolution == .uhd,
                   hertz == .twentyFour {
                    hertz = .thirty
                }
            } label: {
                Text(displayResolution.rawValue)
                    .foregroundStyle(displayResolution == .uhd ? .yellow : .white)
                    .font(.system(size: 13))
                    .fontWeight((displayResolution == .uhd ? .medium : .regular))
                    .monospacedDigit()
            }
            .debugBorder()
            .rotationEffect(rotationAngle(for: deviceOrientation), anchor: .center)
            .animation(.easeInOut(duration: 0.3), value: deviceOrientation)
            
            Text("・")
                .padding(.horizontal, 4)
            
            Button {
                switch displayResolution {
                case .hd:
                    // 가독성 고려해 보기
                    hertz = (hertz == .sixty) ? .thirty : .sixty
                case .uhd:
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
