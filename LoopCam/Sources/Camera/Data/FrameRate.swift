import Foundation

///
enum FrameRate: Int {
    case fps30 = 30
    case fps60 = 60
    
    var text: String {
        switch self {
        case .fps30:
            return "30"
        case .fps60:
            return "60"
        }
    }
}
