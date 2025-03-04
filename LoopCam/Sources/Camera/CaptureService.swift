import Foundation
import AVFoundation
import Combine

actor CaptureService {
    
    private let session = AVCaptureSession()
    private var isSetUp = false
    
    private var output: AVCapturePhotoOutput?
    private var deviceInput: AVCaptureDeviceInput?
    
    var isAuthorized: Bool {
        get async {
            let status = AVCaptureDevice.authorizationStatus(for: .video)
            var isAuthorized = status == .authorized
            
            if status == .notDetermined {
                isAuthorized = await AVCaptureDevice.requestAccess(for: .video)
            }
            
            return isAuthorized
        }
    }
    
    // After you’ve configured inputs, outputs, and previews, call
    func start() async throws {
        guard await isAuthorized, !session.isRunning else { return }
        
        try setupSession()
        session.startRunning()
    }
    
    // All capture sessions need at least one capture input and capture output.
    @discardableResult
    private func addInput(for device: AVCaptureDevice) throws -> AVCaptureDeviceInput {
        let input = try AVCaptureDeviceInput(device: device)
        if session.canAddInput(input) {
            session.addInput(input)
        } else {
            throw CameraError.addInputFailed
        }
        return input
    }
    
    // Adds an output to the capture session to connect the specified capture device, if allowed.
    private func addOutput(_ output: AVCaptureOutput) throws {
        if session.canAddOutput(output) {
            session.addOutput(output)
        } else {
            throw CameraError.addOutputFailed
        }
    }
    
    private func setupSession() throws {
        guard !isSetUp else { return }
        
        do {
            //FIXME: - Fix Hard Coding
            session.sessionPreset = .hd4K3840x2160
            guard let defaultDevice = AVCaptureDevice.default(.builtInWideAngleCamera,
                                                              for: .video,
                                                              position: .unspecified) else { return }
            
            deviceInput = try addInput(for: defaultDevice)
            
            let photoOutput = AVCapturePhotoOutput()
            try addOutput(photoOutput)
            
            let videoOutput = AVCaptureVideoDataOutput()
            try addOutput(videoOutput)
            setDisplayResolution()
            
            isSetUp = true
        } catch {
            throw CameraError.setupFailed
        }
    }
    
    // MARK: - Preview handling
    nonisolated var previewSource: PreviewSource { DefaultPreviewSource(session: session) }
    
    // MARK: - Display resolution and hertz handling
    
    func setDisplayResolution() {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
    }
    
    // MARK: - Automatic focus and exposure handling
    
    // MARK: - Capture handling
    
}
