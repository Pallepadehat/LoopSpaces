import SwiftUI
import AppKit

/// A view displaying a thumbnail for a macOS space
struct SpaceThumbnail: View {
    let space: Space
    let isSelected: Bool
    let onSelect: () -> Void
    
    init(space: Space, isSelected: Bool, onSelect: @escaping () -> Void) {
        print("Creating SpaceThumbnail for space \(space.id), has thumbnail: \(space.thumbnail != nil)")
        self.space = space
        self.isSelected = isSelected
        self.onSelect = onSelect
    }
    
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
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
                    .onAppear {
                        print("Thumbnail image appeared for space \(space.id)")
                    }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 160, height: 100)
                    .cornerRadius(12)
                    .overlay(
                        Text("Space \(space.id)")
                            .foregroundColor(.white)
                    )
                    .onAppear {
                        print("Placeholder rectangle appeared for space \(space.id) - no thumbnail")
                    }
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
            print("Space \(space.id) thumbnail tapped")
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