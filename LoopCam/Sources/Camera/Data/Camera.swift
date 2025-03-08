import Foundation

protocol Camera: AnyObject {
    var previewSource: PreviewSource { get }
    var captureActivity: CaptureActivity { get }
    
    func start() async
    func toggleRecording()
    func switchCamera()
}
