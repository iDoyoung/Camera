import Foundation

protocol Camera: AnyObject {
    var previewSource: PreviewSource { get }
    var captureActivity: CaptureActivity { get }
    var displayResolution: DisplayResolution { get }
    
    func start() async
    func toggleRecording()
    func switchCamera()
    func setDisplayResolution(_ resolution: DisplayResolution)
}
