//
//  ContentView.swift
//  LoopSpaces
//
//  Created by Patrick Jakobsen on 13/05/2025.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var spacesService = SpacesService()
    @StateObject private var windowManager = WindowManager()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
    private var hotkeyManager = HotkeyManager()
    
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
        }
        .padding()
        .frame(minWidth: 400, minHeight: 300)
        .onAppear {
            setupHotkey()
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
        case 50:
            description += "`"
        default:
            description += "[\(settingsViewModel.hotkeyKeyCode)]"
        }
        
        return description
    }
    
    private func setupHotkey() {
        hotkeyManager.registerHotkey(
            key: settingsViewModel.hotkeyKeyCode,
            modifiers: settingsViewModel.modifierFlags
        ) {
            toggleSpacesSwitcher()
        }
    }
    
    private func toggleSpacesSwitcher() {
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
            .environmentObject(windowManager)
        )
    }
    
    private func showSettings() {
        // In a real app, we'd show a proper settings window here
        // For this demo, we'll just print a message
        print("Settings would be shown here")
        
        // You'd typically present the settings window like this:
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
