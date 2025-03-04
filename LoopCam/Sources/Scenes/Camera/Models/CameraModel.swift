import Foundation

@Observable
final class CameraModel: Camera {
    private let captureService = CaptureService()
    private(set) var status: CameraStatus = .unknown
    
    var previewSource: PreviewSource { captureService.previewSource }
    
    func start() async {
        guard await captureService.isAuthorized else {
            status = .unauthorized
            return
        }
        
        do {
            try await captureService.start()
        } catch {
            status = .failed
        }
    }
}
