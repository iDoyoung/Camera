import AVFoundation

enum DisplayResolution {
    case UHD4K
    case HD1080p
    case HD720p
    
    var preset: AVCaptureSession.Preset {
        switch self {
        case .UHD4K:
            return .hd4K3840x2160
        case .HD1080p:
            return .hd1920x1080
        case .HD720p:
            return .hd1280x720
        }
    }
    
    var text: String {
        switch self {
        case .UHD4K:
            return "4K"
        case .HD1080p:
            return "HD"
        case .HD720p:
            return "HD"
        }
    }
}
