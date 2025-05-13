//
//  LoopSpacesApp.swift
//  LoopSpaces
//
//  Created by Patrick Jakobsen on 13/05/2025.
//

import SwiftUI
import AppKit

@main
struct LoopSpacesApp: App {
    // Menu bar manager to keep the app running in the background
    @StateObject private var menuBarManager = MenuBarManager()
    
    init() {
        print("LoopSpaces app initializing...")
        // Don't try to access NSApp directly in init as it might not be ready yet
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuBarManager)
                .onAppear {
                    print("ContentView appeared")
                    
                    // Ensure the window is visible and app is properly configured
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                        // Use NSApplication.shared directly instead of trying to access it through the delegate
                        NSApplication.shared.setActivationPolicy(.regular)
                        NSApplication.shared.activate(ignoringOtherApps: true)
                        
                        if let window = NSApplication.shared.windows.first {
                            print("Making window key and front")
                            window.makeKeyAndOrderFront(nil)
                        } else {
                            print("No window found to make key and front")
                        }
                    }
                }
        }
        .windowStyle(.hiddenTitleBar)
        .commands {
            // Add menus and keyboard shortcuts
            CommandGroup(replacing: .appInfo) {
                Button("About LoopSpaces") {
                    showAboutPanel()
                }
            }
            
            CommandGroup(replacing: .newItem) {}  // Remove New item
            
            CommandMenu("Developer") {
                Button("Reset Preferences") {
                    resetPreferences()
                }
            }
        }
        
        // Settings scene for macOS settings
        Settings {
            SettingsView(viewModel: SettingsViewModel())
        }
    }
    
    private func showAboutPanel() {
        NSApplication.shared.orderFrontStandardAboutPanel(
            options: [
                NSApplication.AboutPanelOptionKey.applicationName: "LoopSpaces",
                NSApplication.AboutPanelOptionKey.applicationVersion: "1.0.0",
                NSApplication.AboutPanelOptionKey.credits: NSAttributedString(
                    string: "A macOS utility for switching between Spaces with style.",
                    attributes: [
                        NSAttributedString.Key.font: NSFont.systemFont(ofSize: NSFont.smallSystemFontSize)
                    ]
                )
            ]
        )
    }
    
    private func resetPreferences() {
        // Reset all user defaults for the app
        let bundleId = Bundle.main.bundleIdentifier ?? "com.yourcompany.LoopSpaces"
        UserDefaults.standard.removePersistentDomain(forName: bundleId)
    }
}

/// Manager for the menu bar icon and functionality
class MenuBarManager: ObservableObject {
    private var statusItem: NSStatusItem?
    
    init() {
        print("MenuBarManager initializing...")
        // Don't set up menu bar immediately, delay it to ensure NSApplication is ready
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.setupMenuBar()
        }
    }
    
    private func setupMenuBar() {
        print("Setting up menu bar...")
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        guard let button = statusItem?.button else {
            print("ERROR: Failed to get status item button")
            return
        }
        
        if let iconImage = NSImage(systemSymbolName: "square.grid.3x2.fill", accessibilityDescription: "LoopSpaces") {
            button.image = iconImage
            print("Menu bar icon set")
        } else {
            print("WARNING: Failed to create system symbol image")
            // Fallback to a simple square as icon
            button.title = "□"
        }
        
        // Setup the menu
        let menu = NSMenu()
        
        menu.addItem(NSMenuItem(title: "About LoopSpaces", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
        
        statusItem?.menu = menu
        print("Menu bar setup complete")
    }
    
    @objc private func openSettings() {
        // Try to find the settings window and show it
        print("Opening settings...")
        
        // Since we're using the SwiftUI Settings scene, we'll directly use the shared selector
        DispatchQueue.main.async {
            NSApplication.shared.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
        }
    }
}
