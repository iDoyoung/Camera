import SwiftUI

struct RecordingStatusView: View {
    
    @State private var isBlinking = false
    @State private var size: CGFloat = 11
    
    var body: some View {
        HStack {
            Circle()
                .fill(Color(red: 1, green: 0, blue: 0))
                .aspectRatio(1, contentMode: .fit)
                .frame(width: size)
            
            Text("REC")
                .foregroundStyle(.white)
                .font(.system(size: 12, weight: .medium))
        }
        .opacity(isBlinking ? 0 : 1)
        .onAppear {
            withAnimation(Animation.easeInOut(duration: 0.8).repeatForever(autoreverses: true)) {
                isBlinking = true
            }
        }
        
    }
}
