import Foundation
import SwiftUI
import Carbon
import AppKit

/// Manages global hotkey registration and handling
class HotkeyManager {
    typealias HotkeyAction = () -> Void
    
    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    private var action: HotkeyAction?
    
    // Static shared instance for callback access
    private static var shared: HotkeyManager?
    
    init() {
        print("HotkeyManager initializing...")
        HotkeyManager.shared = self
    }
    
    deinit {
        print("HotkeyManager deinitializing...")
        unregisterHotkey()
        if HotkeyManager.shared === self {
            HotkeyManager.shared = nil
        }
    }
    
    /// Register a global hotkey
    /// - Parameters:
    ///   - key: The key code (e.g., kVK_Tab for Tab key)
    ///   - modifiers: Key modifiers (e.g., .command, .option)
    ///   - action: The closure to execute when hotkey is pressed
    func registerHotkey(key: Int, modifiers: NSEvent.ModifierFlags, action: @escaping HotkeyAction) {
        print("Registering hotkey: key=\(key), modifiers=\(modifiers.rawValue)")
        
        // First unregister any existing hotkey
        unregisterHotkey()
        
        self.action = action
        
        // Convert from Cocoa modifier flags to Carbon modifier flags
        var carbonModifiers: UInt32 = 0
        if modifiers.contains(.command) { carbonModifiers |= UInt32(cmdKey) }
        if modifiers.contains(.option) { carbonModifiers |= UInt32(optionKey) }
        if modifiers.contains(.control) { carbonModifiers |= UInt32(controlKey) }
        if modifiers.contains(.shift) { carbonModifiers |= UInt32(shiftKey) }
        
        print("Converted modifiers to Carbon format: \(carbonModifiers)")
        
        // Register for hotkey events
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        // Install event handler with a C callback
        print("Installing event handler...")
        let status = InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, _, _) -> OSStatus in
                print("Hotkey event received")
                // Access through the static shared instance
                if let manager = HotkeyManager.shared {
                    manager.hotkeyPressed()
                } else {
                    print("ERROR: HotkeyManager.shared was nil when hotkey was pressed")
                }
                return noErr
            },
            1,
            &eventType,
            nil,
            &eventHandler
        )
        
        if status != noErr {
            print("ERROR: Failed to install event handler, status: \(status)")
            return
        }
        
        // Register the hotkey
        let hotkeyID = EventHotKeyID(signature: OSType(UserData.hotkeySignature), id: 1)
        
        print("Registering hotkey with Carbon, key: \(key), modifiers: \(carbonModifiers)")
        let registerStatus = RegisterEventHotKey(
            UInt32(key),
            carbonModifiers,
            hotkeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
        
        if registerStatus != noErr {
            print("ERROR: Failed to register hotkey, status: \(registerStatus)")
            // Clean up the event handler if hotkey registration failed
            if let eventHandler = eventHandler {
                RemoveEventHandler(eventHandler)
                self.eventHandler = nil
            }
        } else {
            print("Hotkey registered successfully")
        }
    }
    
    /// Unregister the hotkey
    func unregisterHotkey() {
        if let eventHandler = eventHandler {
            print("Removing event handler...")
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
        
        if let hotKeyRef = hotKeyRef {
            print("Unregistering hotkey...")
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
    }
    
    private func hotkeyPressed() {
        print("Hotkey pressed, invoking action...")
        DispatchQueue.main.async { [weak self] in
            self?.action?()
        }
    }
    
    /// Namespace for static values
    private enum UserData {
        static let hotkeySignature: Int = 1234
    }
} 