import Foundation
import AVFoundation
import Combine

actor CaptureService {
    
    @Published private(set) var captureActivity: CaptureActivity = .idle
    
    private let session = AVCaptureSession()
    private var isSetUp = false
    
    private var deviceInput: AVCaptureDeviceInput?
    private var currentDevice: AVCaptureDevice {
        guard let device = deviceInput?.device else { fatalError("No device input") }
        return  device
    }
    
    // Devices
    private var defaultCamera: AVCaptureDevice {
        if AVCaptureDevice.systemPreferredCamera == nil {
            AVCaptureDevice.userPreferredCamera = backCameraDiscoverySession.devices.first
        }
        
        guard let videoDevice = AVCaptureDevice.systemPreferredCamera else {
            fatalError("No default camera")
        }
        return videoDevice
    }
    
    private let backCameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTripleCamera, .builtInDualCamera, .builtInWideAngleCamera],
                                                                              mediaType: .video,
                                                                              position: .back)
    
    private let frontCameraDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInTrueDepthCamera, .builtInWideAngleCamera],
                                                                               mediaType: .video,
                                                                               position: .front)
    
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
        videoCapture.$activity.assign(to: &$captureActivity)
        
        do {
            //FIXME: - Fix Hard Coding
            session.sessionPreset = .hd4K3840x2160
            deviceInput = try addInput(for: defaultCamera)
            
            try addOutput(videoCapture.output)
            try setDisplayResolution(.HD1080p)
            
            isSetUp = true
        } catch {
            throw CameraError.setupFailed
        }
    }
    
    // MARK: - Preview handling
    nonisolated var previewSource: PreviewSource { DefaultPreviewSource(session: session) }
    
    func switchCaptureDevice() {
        guard let currentInput = deviceInput else { return }
        session.beginConfiguration()
        defer  { session.commitConfiguration() }
        
        let position = currentDevice.position
        session.removeInput(currentInput)
        var device: AVCaptureDevice?
        do {
            switch position {
            case .back:
                device = frontCameraDiscoverySession.devices.first
            case .front:
                device = backCameraDiscoverySession.devices.first
            case .unspecified:
                break
            @unknown default:
                break
            }
            
            guard let device else {
                throw CameraError.deviceChangeFailed
            }
            deviceInput = try addInput(for: device)
        } catch {
            session.addInput(currentInput)
        }
        AVCaptureDevice.userPreferredCamera = device
    }
    
    // MARK: - Display resolution and frame rates handling
    
    func setDisplayResolution(_ resolution: DisplayResolution) throws {
        session.beginConfiguration()
        defer { session.commitConfiguration() }
        do {
            try currentDevice.lockForConfiguration()
            session.sessionPreset = resolution.preset
            currentDevice.unlockForConfiguration()
        } catch {
            throw CameraError.setupFailed
        }
        logger.log("Current display resolution: \(String(describing: self.session.sessionPreset))\nFrame rate: \(String(describing: self.currentDevice.activeFormat.videoSupportedFrameRateRanges))")
    }
    
    func setFrameRate(_ frameRate: FrameRate) throws {
        
        try currentDevice.lockForConfiguration()
        let currentDimensions = CMVideoFormatDescriptionGetDimensions(currentDevice.activeFormat.formatDescription)
        let timescale = CMTimeScale(frameRate.rawValue)
        var selectedFormat: AVCaptureDevice.Format? = nil
        
        for format in currentDevice.formats {
            let dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription)
            let ranges = format.videoSupportedFrameRateRanges
           
            if ranges.contains(where: { $0.maxFrameRate == Double(frameRate.rawValue) }) {
                if dimensions.height == currentDimensions.height && dimensions.width == currentDimensions.width {
                    selectedFormat = format
                }
            }
        }
        
        if let selectedFormat = selectedFormat {
            currentDevice.activeFormat = selectedFormat
            currentDevice.activeVideoMinFrameDuration = CMTime(value: 1, timescale: timescale)
            currentDevice.activeVideoMaxFrameDuration = CMTime(value: 1, timescale: timescale)
            
            logger.log("Current display resolution: \(String(describing: self.session.sessionPreset.rawValue))\nFrame rate: \(String(describing: self.currentDevice.activeFormat.videoSupportedFrameRateRanges))")
        }
        
        currentDevice.unlockForConfiguration()
    }
    
    // MARK: - Automatic focus and exposure handling
    
    // MARK: - Capture handling
    private let videoCapture = VideoCapture()
    
    func startRecording() {
        videoCapture.record()
    }
    
    func stopRecording() async throws -> Video {
        try await videoCapture.stop()
    }
}
