import SwiftUI

/// View model for app settings
class SettingsViewModel: ObservableObject {
    @Published var hotkeyModifiers: UInt {
        didSet {
            UserDefaults.standard.set(hotkeyModifiers, forKey: "hotkeyModifiers")
        }
    }
    
    @Published var hotkeyKeyCode: Int {
        didSet {
            UserDefaults.standard.set(hotkeyKeyCode, forKey: "hotkeyKeyCode")
        }
    }
    
    init() {
        // Load from UserDefaults or use default values
        // Default to Command (256) + Option (2048) = 2304
        self.hotkeyModifiers = UserDefaults.standard.object(forKey: "hotkeyModifiers") as? UInt ?? 2304
        // Default to Tab key (48)
        self.hotkeyKeyCode = UserDefaults.standard.object(forKey: "hotkeyKeyCode") as? Int ?? 48
    }
    
    var modifierFlags: NSEvent.ModifierFlags {
        return NSEvent.ModifierFlags(rawValue: UInt(hotkeyModifiers))
    }
    
    func setModifierFlags(_ flags: NSEvent.ModifierFlags) {
        hotkeyModifiers = flags.rawValue
    }
}

/// Settings view for the app
struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    @State private var isRecordingHotkey = false
    @State private var recordedModifiers: NSEvent.ModifierFlags = []
    @State private var recordedKeyCode: Int = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Form {
                Section {
                    VStack(alignment: .leading) {
                        Text("Hotkey")
                            .font(.headline)
                        
                        // Hotkey recorder
                        HStack {
                            if isRecordingHotkey {
                                Text("Press a key combination...")
                                    .foregroundColor(.secondary)
                            } else {
                                HStack(spacing: 4) {
                                    // Show modifier keys
                                    if viewModel.modifierFlags.contains(.command) {
                                        KeyCapView(symbol: "command")
                                    }
                                    if viewModel.modifierFlags.contains(.option) {
                                        KeyCapView(symbol: "option")
                                    }
                                    if viewModel.modifierFlags.contains(.control) {
                                        KeyCapView(symbol: "control")
                                    }
                                    if viewModel.modifierFlags.contains(.shift) {
                                        KeyCapView(symbol: "shift")
                                    }
                                    
                                    // Show the main key
                                    Text(keyCodeToString(viewModel.hotkeyKeyCode))
                                        .font(.system(size: 12, weight: .bold))
                                        .foregroundColor(.primary)
                                        .frame(width: 24, height: 24)
                                        .background(
                                            RoundedRectangle(cornerRadius: 6)
                                                .fill(Color.secondary.opacity(0.2))
                                        )
                                }
                            }
                            
                            Spacer()
                            
                            Button(isRecordingHotkey ? "Cancel" : "Record") {
                                isRecordingHotkey.toggle()
                            }
                            .buttonStyle(.borderedProminent)
                            .controlSize(.small)
                        }
                        .padding()
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                        
                        Text("Press the key combination you want to use to trigger the spaces switcher.")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Divider()
                
                Section {
                    Text("About LoopSpaces")
                        .font(.headline)
                    
                    Text("Version 1.0.0")
                        .foregroundColor(.secondary)
                    
                    Link("View on GitHub", destination: URL(string: "https://github.com/yourusername/LoopSpaces")!)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
            .formStyle(.grouped)
        }
        .padding()
        .frame(width: 400, height: 300)
        .onAppear {
            setupHotkeyRecording()
        }
    }
    
    // Set up local event monitor to capture keystrokes for hotkey recording
    private func setupHotkeyRecording() {
        // This would set up a local event monitor in a real implementation
        // For now, we'll just use a placeholder
    }
    
    private func keyCodeToString(_ keyCode: Int) -> String {
        // This is a simplified version - in a real app, you'd map all keys
        switch keyCode {
        case 0: return "A"
        case 1: return "S"
        case 2: return "D"
        case 3: return "F"
        case 12: return "Q"
        case 13: return "W"
        case 14: return "E"
        case 15: return "R"
        case 50: return "`"
        case 53: return "⎋"
        case 36: return "↩"
        case 48: return "⇥"
        default: return "\(keyCode)"
        }
    }
}

#Preview {
    SettingsView(viewModel: SettingsViewModel())
} 