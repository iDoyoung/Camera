import Foundation

@Observable
final class CameraModel: Camera {
    
    private let service = CaptureService()
    private(set) var status: CameraStatus = .unknown
    
    private(set) var captureActivity: CaptureActivity = .idle
    var previewSource: PreviewSource { service.previewSource }
    
    func start() async {
        guard await service.isAuthorized else {
            status = .unauthorized
            return
        }
        
        do {
            try await service.start()
            observeCaptureActivity()
            status = .running
        } catch {
            status = .failed
        }
    }
    
    func toggleRecording() {
        Task {
            if await service.captureActivity.isRecording {
                do {
                    try await service.stopRecording()
                } catch {
                    //TODO: Error handlering
                }
            } else {
                await service.startRecording()
            }
        }
    }
    
    func switchCamera() {
        Task { @MainActor in
            await service.switchCaptureDevice()
        }
    }
    
    private func observeCaptureActivity() {
        Task {
            for await activity in await service.$captureActivity.values {
                captureActivity = activity
            }
        }
    }
}
