import Foundation
import SwiftUI

/// Represents a macOS desktop space (virtual desktop)
struct Space: Identifiable, Equatable {
    let id: Int
    let displayName: String
    var thumbnail: NSImage?
    var isActive: Bool
    
    static func == (lhs: Space, rhs: Space) -> Bool {
        lhs.id == rhs.id
    }
    
    /// Create a placeholder space for preview and testing
    static func placeholder(id: Int, isActive: Bool = false) -> Space {
        Space(
            id: id,
            displayName: "Space \(id)",
            thumbnail: nil,
            isActive: isActive
        )
    }
} 