import SwiftUI

/// Generates the app icon for LoopSpaces
struct AppIconGenerator: View {
    var body: some View {
        ZStack {
            // Background gradient
            LinearGradient(
                gradient: Gradient(colors: [Color.blue, Color.purple]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .mask {
                RoundedRectangle(cornerRadius: 22, style: .continuous)
            }
            
            // Spaces grid icon
            ZStack {
                // Grid background
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white.opacity(0.2))
                    .frame(width: 80, height: 60)
                
                // Grid cells
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white)
                            .frame(width: 22, height: 15)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.8))
                            .frame(width: 22, height: 15)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.6))
                            .frame(width: 22, height: 15)
                    }
                    
                    HStack(spacing: 4) {
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.5))
                            .frame(width: 22, height: 15)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.9))
                            .frame(width: 22, height: 15)
                        
                        RoundedRectangle(cornerRadius: 4)
                            .fill(.white.opacity(0.7))
                            .frame(width: 22, height: 15)
                    }
                }
            }
            
            // Loop arrow
            Circle()
                .trim(from: 0.7, to: 1.0)
                .stroke(.white, style: StrokeStyle(lineWidth: 10, lineCap: .round))
                .frame(width: 100, height: 100)
                .rotationEffect(.degrees(-90))
                .scaleEffect(0.9)
        }
        .frame(width: 1024, height: 1024) // Standard app icon size
    }
}

#Preview {
    AppIconGenerator()
        .previewLayout(.sizeThatFits)
        .padding()
        .background(Color.black)
} 