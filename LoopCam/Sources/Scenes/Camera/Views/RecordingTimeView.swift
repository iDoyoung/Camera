import SwiftUI

struct RecordingTimeView: View {
    
    let time: TimeInterval
   
    var body: some View {
        Text(time.formatted)
            .padding([.leading, .trailing], 12)
            .padding([.top, .bottom], 6)
            .background(Color(white: 0.0, opacity: 0.5))
            .foregroundColor(.white)
            .font(.title3.weight(.regular))
            .clipShape(.capsule)
            .monospacedDigit()
    }
}
