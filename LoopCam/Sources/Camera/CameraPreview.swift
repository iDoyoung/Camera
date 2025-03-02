import SwiftUI
import AVFoundation

struct CameraPreview: UIViewRepresentable {
    
    func makeUIView(context: Context) -> PreviewView {
        let previewView = PreviewView()
        return previewView
    }
    
    func updateUIView(_ previewView: PreviewView, context: Context) {   }
}

final class PreviewView: UIView {
    
    var videoPreviewLayer: AVCaptureVideoPreviewLayer {
        guard let layer = layer as? AVCaptureVideoPreviewLayer else {
            fatalError("Expected `AVCaptureVideoPreviewLayer` type for layer. Check PreviewView.layerClass implementation.")
        }
        return layer
    }
    
    override class var layerClass: AnyClass {
        return AVCaptureVideoPreviewLayer.self
    }
    
    func setSession(_ session: AVCaptureSession) {
        videoPreviewLayer.session = session
    }
}
