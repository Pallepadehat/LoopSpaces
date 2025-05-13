import Foundation
import SwiftUI

/// Service to interact with macOS Spaces functionality
class SpacesService: ObservableObject {
    @Published var spaces: [Space] = []
    @Published var activeSpaceId: Int = 1
    
    init() {
        refreshSpaces()
    }
    
    /// Refreshes the list of spaces and their active state
    func refreshSpaces() {
        // In a real implementation, we would use private APIs to get actual spaces
        // For now, we're creating mock data
        
        // Get the current active space (would use private API)
        activeSpaceId = 1
        
        // Get all spaces (would use private API)
        spaces = (1...5).map { id in
            Space(
                id: id,
                displayName: "Space \(id)",
                thumbnail: createPlaceholderThumbnail(forId: id),
                isActive: id == activeSpaceId
            )
        }
    }
    
    /// Switch to a specific space
    func switchToSpace(_ space: Space) {
        // In a real implementation, this would use private APIs to switch spaces
        print("Switching to space \(space.id)")
        
        // Update our model
        activeSpaceId = space.id
        updateActiveSpace()
    }
    
    /// Update which space is marked as active
    private func updateActiveSpace() {
        for i in 0..<spaces.count {
            spaces[i].isActive = spaces[i].id == activeSpaceId
        }
    }
    
    /// Create a placeholder thumbnail for preview/demo purposes
    private func createPlaceholderThumbnail(forId id: Int) -> NSImage {
        let size = CGSize(width: 300, height: 200)
        let image = NSImage(size: size)
        
        image.lockFocus()
        
        // Fill background
        let colors: [NSColor] = [.systemBlue, .systemGreen, .systemPink, .systemPurple, .systemOrange]
        let color = colors[id % colors.count].withAlphaComponent(0.3)
        color.setFill()
        NSRect(origin: .zero, size: size).fill()
        
        // Draw text
        let text = "Space \(id)"
        let font = NSFont.systemFont(ofSize: 24, weight: .bold)
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: NSColor.textColor
        ]
        
        let textSize = text.size(withAttributes: attributes)
        let rect = NSRect(
            x: (size.width - textSize.width) / 2,
            y: (size.height - textSize.height) / 2,
            width: textSize.width,
            height: textSize.height
        )
        
        text.draw(in: rect, withAttributes: attributes)
        
        image.unlockFocus()
        return image
    }
} 