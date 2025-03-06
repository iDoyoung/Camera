import AVFoundation
import Combine

/// Manages a video capture output to record videos
final class VideoCapture {
    
    @Published private(set) var activity: CaptureActivity = .idle
    let output = AVCaptureMovieFileOutput()
    let dataoutput = AVCaptureVideoDataOutput()
    
    // An internal alias for the output.
    private var movieOutput: AVCaptureMovieFileOutput { output }
    
    private var delegate: VideoCaptureDelegate?
    
    private var timerCancellable: AnyCancellable?
    private let refreshInterval = TimeInterval(0.25)
    
    func record() {
        guard movieOutput.isRecording == false else { return }
        guard let connection = output.connection(with: .video) else {
            fatalError("No video conneciton found.")
        }
        
        if movieOutput.availableVideoCodecTypes.contains(.hevc) {
            movieOutput.setOutputSettings([AVVideoCodecKey: AVVideoCodecType.hevc], for: connection)
        }
        
        //TODO: 손떨립 방지모드를 사용자가 컨트롤 할 수 있게 해야할지
        if connection.isVideoStabilizationSupported {
            connection.preferredVideoStabilizationMode = .auto
        }
        
        // Start a timer
        activity = .videoCapture()
        // Update recording time
        timerCancellable = Timer.publish(every: refreshInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                guard let self = self else { return }
                let duration = output.recordedDuration.seconds
                activity = .videoCapture(duration: duration)
            }
        
        delegate = VideoCaptureDelegate()
        guard let delegate else { fatalError("Failed to create delegate") }
        output.startRecording(to: URL.movieFileURL, recordingDelegate: delegate)
    }
    
    func stop() async throws -> Video {
        return try await  withCheckedThrowingContinuation { continuation in
            delegate?.continuation = continuation
            movieOutput.stopRecording()
            
            // Update Timer
            timerCancellable?.cancel()
            activity = .idle
        }
    }
}

final class VideoCaptureDelegate: NSObject, AVCaptureFileOutputRecordingDelegate {
    
    var continuation: CheckedContinuation<Video, Error>?
    
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: (any Error)?) {
        if let error {
            continuation?.resume(throwing: error)
        } else {
            continuation?.resume(returning: Video(url: outputFileURL))
        }
    }
}
