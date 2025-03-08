import Foundation

@Observable
final class CameraModel: Camera {
    
    private let service = CaptureService()
    
    private(set) var status: CameraStatus = .unknown
    private(set) var captureActivity: CaptureActivity = .idle
    private(set) var displayResolution: DisplayResolution = .HD1080p
    
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
    
    func setDisplayResolution(_ resolution: DisplayResolution) {
        displayResolution = resolution
        Task {
            do {
                try await service.setDisplayResolution(resolution)
            } catch {
                //에러 발생시 HD 화질
                displayResolution = .HD1080p
            }
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
