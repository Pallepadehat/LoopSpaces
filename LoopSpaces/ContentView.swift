//
//  ContentView.swift
//  LoopSpaces
//
//  Created by Patrick Jakobsen on 13/05/2025.
//

import SwiftUI
import AppKit

struct ContentView: View {
    @StateObject private var spacesService = SpacesService()
    @StateObject private var windowManager = WindowManager()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    // Don't initialize the hotkey manager directly as a property
    // Instead, create it in onAppear and store it in a state variable
    @State private var hotkeyManager: HotkeyManager?
    
    init() {
        print("ContentView initializing...")
    }
    
    var body: some View {
        VStack {
            Image(systemName: "square.grid.3x2.fill")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 64))
            
            Text("LoopSpaces")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 1)
            
            Text("Press \(hotkeyDescription) to activate")
                .foregroundStyle(.secondary)
            
            Button("Settings") {
                showSettings()
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 20)
            
            // Debug button
            Button("Test Overlay") {
                toggleSpacesSwitcher()
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            print("ContentView body appeared")
            // Create the hotkey manager and set it up after the view appears
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                setupHotkey()
            }
        }
    }
    
    private var hotkeyDescription: String {
        var description = ""
        
        if settingsViewModel.modifierFlags.contains(.command) {
            description += "⌘"
        }
        if settingsViewModel.modifierFlags.contains(.option) {
            description += "⌥"
        }
        if settingsViewModel.modifierFlags.contains(.control) {
            description += "⌃"
        }
        if settingsViewModel.modifierFlags.contains(.shift) {
            description += "⇧"
        }
        
        switch settingsViewModel.hotkeyKeyCode {
        case 48:
            description += "⇥"
        case 50:
            description += "`"
        default:
            description += "[\(settingsViewModel.hotkeyKeyCode)]"
        }
        
        return description
    }
    
    private func setupHotkey() {
        print("Setting up hotkey: modifiers=\(settingsViewModel.hotkeyModifiers), keyCode=\(settingsViewModel.hotkeyKeyCode)")
        
        // Create a new hotkey manager
        let manager = HotkeyManager()
        
        // Register the hotkey
        manager.registerHotkey(
            key: settingsViewModel.hotkeyKeyCode,
            modifiers: settingsViewModel.modifierFlags
        ) { [weak windowManager, weak spacesService] in
            print("Hotkey triggered!")
            // Use weak references to avoid retain cycles
            guard let windowManager = windowManager, let spacesService = spacesService else {
                print("ERROR: windowManager or spacesService was nil when hotkey was triggered")
                return
            }
            
            // Refresh spaces and show the overlay
            spacesService.refreshSpaces()
            
            DispatchQueue.main.async {
                windowManager.toggleOverlay(rootView: 
                    SpacesSwitcherOverlay(
                        spacesService: spacesService,
                        onSpaceSelected: { space in
                            spacesService.switchToSpace(space)
                            windowManager.hideOverlay()
                        },
                        onDismiss: {
                            windowManager.hideOverlay()
                        }
                    )
                )
            }
        }
        
        // Store the manager to keep it alive
        self.hotkeyManager = manager
    }
    
    private func toggleSpacesSwitcher() {
        print("Toggling spaces switcher")
        spacesService.refreshSpaces()
        
        windowManager.toggleOverlay(rootView: 
            SpacesSwitcherOverlay(
                spacesService: spacesService,
                onSpaceSelected: { space in
                    spacesService.switchToSpace(space)
                    windowManager.hideOverlay()
                },
                onDismiss: {
                    windowManager.hideOverlay()
                }
            )
        )
    }
    
    private func showSettings() {
        print("Showing settings window")
        
        let settingsWindow = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 400, height: 300),
            styleMask: [.titled, .closable, .resizable],
            backing: .buffered,
            defer: false
        )
        
        settingsWindow.center()
        settingsWindow.title = "LoopSpaces Settings"
        settingsWindow.contentView = NSHostingView(rootView: SettingsView(viewModel: settingsViewModel))
        settingsWindow.makeKeyAndOrderFront(nil)
    }
}

#Preview {
    ContentView()
}
