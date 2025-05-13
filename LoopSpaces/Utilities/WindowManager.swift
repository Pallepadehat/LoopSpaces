import Foundation
import SwiftUI
import AppKit

/// Manages the overlay window for space switching
class WindowManager: ObservableObject {
    private var window: NSWindow?
    @Published var isVisible: Bool = false
    
    /// Show the overlay window
    /// - Parameter rootView: The SwiftUI view to display in the window
    func showOverlay<Content: View>(rootView: Content) {
        if window == nil {
            let contentView = NSHostingView(rootView: rootView)
            
            // Create a panel window that appears above all other windows
            let panel = NSPanel(
                contentRect: NSRect(x: 0, y: 0, width: 800, height: 300),
                styleMask: [.borderless, .nonactivatingPanel],
                backing: .buffered,
                defer: false
            )
            
            panel.contentView = contentView
            panel.backgroundColor = .clear
            panel.isOpaque = false
            panel.hasShadow = false
            panel.level = .floating
            panel.collectionBehavior = [.canJoinAllSpaces, .stationary]
            
            // Make it center-aligned on screen
            self.centerWindowOnScreen(panel)
            
            self.window = panel
        }
        
        guard let window = self.window else { return }
        
        // Show the window without taking focus
        window.orderFrontRegardless()
        window.makeKey()
        
        isVisible = true
    }
    
    /// Hide the overlay window
    func hideOverlay() {
        window?.orderOut(nil)
        isVisible = false
    }
    
    /// Toggle the overlay visibility
    /// - Parameter rootView: The SwiftUI view to display in the window
    func toggleOverlay<Content: View>(rootView: Content) {
        if isVisible {
            hideOverlay()
        } else {
            showOverlay(rootView: rootView)
        }
    }
    
    /// Center the window on the active screen
    /// - Parameter window: The window to center
    private func centerWindowOnScreen(_ window: NSWindow) {
        if let screen = NSScreen.main {
            let screenRect = screen.frame
            let windowRect = window.frame
            
            let origin = NSPoint(
                x: screenRect.midX - windowRect.width / 2,
                y: screenRect.midY - windowRect.height / 2
            )
            
            window.setFrameOrigin(origin)
        }
    }
} 