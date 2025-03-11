import Foundation

protocol Camera: AnyObject {
    var previewSource: PreviewSource { get }
    var captureActivity: CaptureActivity { get }
    var displayResolution: DisplayResolution { get }
    var frameRate: FrameRate { get }
    
    func start() async
    func toggleRecording()
    func switchCamera()
    func setDisplayResolution(_ resolution: DisplayResolution) async
    func setFrameRate(_ frameRate: FrameRate) async
}
