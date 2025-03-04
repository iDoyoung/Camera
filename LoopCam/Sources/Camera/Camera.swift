import Foundation

protocol Camera: AnyObject {
    var previewSource: PreviewSource { get }
    func start() async
}
