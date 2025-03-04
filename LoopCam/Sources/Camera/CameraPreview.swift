import SwiftUI
import AVFoundation

protocol PreviewTarget {
    // Sets the capture session on the destination.
    func setSession(_ session: AVCaptureSession)
}

struct CameraPreview: UIViewRepresentable {
    
    private let source: PreviewSource
    
    init(source: PreviewSource) {
        self.source = source
    }
    
    func makeUIView(context: Context) -> PreviewView {
        let previewView = PreviewView()
        source.connect(to: previewView)
            
        return previewView
    }
    
    func updateUIView(_ previewView: PreviewView, context: Context) {   }
}

final class PreviewView: UIView, PreviewTarget {
    
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
