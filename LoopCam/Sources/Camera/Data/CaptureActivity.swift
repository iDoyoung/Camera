import Foundation

enum CaptureActivity {
    case idle
    case videoCapture(duration: TimeInterval = 0.0)
    
    var currentTime: TimeInterval {
        if case .videoCapture(let duration) = self {
            return duration
        } else {
            return .zero
        }
    }
    
    var isRecording: Bool {
        if case .videoCapture(_) = self {
            return true
        } else {
            return false
        }
    }
}
