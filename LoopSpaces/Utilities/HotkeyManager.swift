import Foundation
import SwiftUI
import Carbon

/// Manages global hotkey registration and handling
class HotkeyManager {
    typealias HotkeyAction = () -> Void
    
    private var eventHandler: EventHandlerRef?
    private var hotKeyRef: EventHotKeyRef?
    private var action: HotkeyAction?
    
    deinit {
        unregisterHotkey()
    }
    
    /// Register a global hotkey
    /// - Parameters:
    ///   - key: The key code (e.g., kVK_Tab for Tab key)
    ///   - modifiers: Key modifiers (e.g., .command, .option)
    ///   - action: The closure to execute when hotkey is pressed
    func registerHotkey(key: Int, modifiers: NSEvent.ModifierFlags, action: @escaping HotkeyAction) {
        self.action = action
        
        // Convert from Cocoa modifier flags to Carbon modifier flags
        var carbonModifiers: UInt32 = 0
        if modifiers.contains(.command) { carbonModifiers |= UInt32(cmdKey) }
        if modifiers.contains(.option) { carbonModifiers |= UInt32(optionKey) }
        if modifiers.contains(.control) { carbonModifiers |= UInt32(controlKey) }
        if modifiers.contains(.shift) { carbonModifiers |= UInt32(shiftKey) }
        
        // Register for hotkey events
        var eventType = EventTypeSpec()
        eventType.eventClass = OSType(kEventClassKeyboard)
        eventType.eventKind = OSType(kEventHotKeyPressed)
        
        // Install event handler
        InstallEventHandler(
            GetApplicationEventTarget(),
            { (_, eventRef, _) -> OSStatus in
                guard let strongSelf = Unmanaged<HotkeyManager>.fromOpaque(
                    UnsafeRawPointer(bitPattern: UInt(UserData.hotkeyManagerPtr))!
                ).takeUnretainedValue() else {
                    return noErr
                }
                
                strongSelf.hotkeyPressed()
                return noErr
            },
            1,
            &eventType,
            nil,
            &eventHandler
        )
        
        // Register the hotkey
        let hotkeyID = EventHotKeyID(signature: OSType(UserData.hotkeySignature), id: 1)
        
        RegisterEventHotKey(
            UInt32(key),
            carbonModifiers,
            hotkeyID,
            GetApplicationEventTarget(),
            0,
            &hotKeyRef
        )
    }
    
    /// Unregister the hotkey
    func unregisterHotkey() {
        if let eventHandler = eventHandler {
            RemoveEventHandler(eventHandler)
            self.eventHandler = nil
        }
        
        if let hotKeyRef = hotKeyRef {
            UnregisterEventHotKey(hotKeyRef)
            self.hotKeyRef = nil
        }
    }
    
    private func hotkeyPressed() {
        action?()
    }
    
    /// Namespace for static values
    private enum UserData {
        static let hotkeyManagerPtr: Int = 1000
        static let hotkeySignature: Int = 1234
    }
} 