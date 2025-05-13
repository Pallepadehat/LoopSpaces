import Foundation
import SwiftUI
import AppKit

/// Manages the overlay window for space switching
class WindowManager: ObservableObject {
    private var window: NSWindow?
    @Published var isVisible: Bool = false
    
    init() {
        print("WindowManager initialized")
    }
    
    /// Show the overlay window
    /// - Parameter rootView: The SwiftUI view to display in the window
    func showOverlay<Content: View>(rootView: Content) {
        print("showOverlay called")
        if window == nil {
            print("Creating new window")
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
            print("Window created")
        }
        
        guard let window = self.window else {
            print("ERROR: Window is nil after creation")
            return
        }
        
        // Show the window without taking focus
        print("Displaying window")
        window.orderFrontRegardless()
        window.makeKey()
        
        isVisible = true
        print("Window should now be visible")
    }
    
    /// Hide the overlay window
    func hideOverlay() {
        print("hideOverlay called")
        window?.orderOut(nil)
        isVisible = false
        print("Window hidden")
    }
    
    /// Toggle the overlay visibility
    /// - Parameter rootView: The SwiftUI view to display in the window
    func toggleOverlay<Content: View>(rootView: Content) {
        print("toggleOverlay called, current visibility: \(isVisible)")
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
            print("Window centered at: \(origin)")
        } else {
            print("ERROR: No main screen found")
        }
    }
} 