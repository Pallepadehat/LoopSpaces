//
//  LoopSpacesApp.swift
//  LoopSpaces
//
//  Created by Patrick Jakobsen on 13/05/2025.
//

import SwiftUI

@main
struct LoopSpacesApp: App {
    // Menu bar manager to keep the app running in the background
    @StateObject private var menuBarManager = MenuBarManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(menuBarManager)
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
        setupMenuBar()
    }
    
    private func setupMenuBar() {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.squareLength)
        
        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "square.grid.3x2.fill", accessibilityDescription: "LoopSpaces")
            
            // Setup the menu
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "About LoopSpaces", action: #selector(NSApplication.orderFrontStandardAboutPanel(_:)), keyEquivalent: ""))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Settings...", action: #selector(openSettings), keyEquivalent: ","))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            statusItem?.menu = menu
        }
    }
    
    @objc private func openSettings() {
        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
    }
}
