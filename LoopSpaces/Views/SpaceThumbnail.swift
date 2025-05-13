import SwiftUI

/// A view displaying a thumbnail for a macOS space
struct SpaceThumbnail: View {
    let space: Space
    let isSelected: Bool
    let onSelect: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            // Thumbnail image
            if let thumbnail = space.thumbnail {
                Image(nsImage: thumbnail)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 160, height: 100)
                    .cornerRadius(12)
                    .shadow(color: .black.opacity(0.2), radius: 5, x: 0, y: 2)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 100)
                    .cornerRadius(12)
            }
            
            // Label
            Text(space.displayName)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white)
        }
        .padding(10)
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(isSelected ? Color.blue.opacity(0.3) : Color.clear)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 16)
                .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 2)
        )
        .scaleEffect(isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.3), value: isSelected)
        .onTapGesture {
            onSelect()
        }
    }
}

#Preview {
    ZStack {
        Color.black.opacity(0.5)
            .edgesIgnoringSafeArea(.all)
        
        SpaceThumbnail(
            space: Space.placeholder(id: 1, isActive: true),
            isSelected: true,
            onSelect: {}
        )
    }
} 