# LoopSpaces

<p align="center">
  <img src="Resources/app-icon.png" width="128" alt="LoopSpaces Logo">
</p>

<h3 align="center">Elegant macOS Space Switching</h3>

<p align="center">
  <img src="https://img.shields.io/badge/platform-macOS-lightgrey" alt="Platform">
  <img src="https://img.shields.io/badge/macOS-11.0+-blue" alt="macOS">
  <img src="https://img.shields.io/badge/license-MIT-green" alt="License">
  <img src="https://img.shields.io/badge/Swift-5.5-orange" alt="Swift">
</p>

## ✨ Features

LoopSpaces is a macOS utility that lets you switch between virtual desktops (Spaces) with a beautiful, intuitive UI — similar to the built-in Cmd + Tab app switcher, but for Spaces.

- 🚀 **Quick Access**: Press your custom hotkey (default: ⌘+`) to activate the spaces switcher overlay
- 🎨 **Beautiful UI**: Modern, translucent UI that feels native to macOS
- 🖱️ **Full Control**: Navigate spaces using arrow keys, mouse, or trackpad
- ⚙️ **Customizable**: Configure your preferred keyboard shortcuts
- 🔄 **Smooth Transitions**: Sleek animations when switching spaces

<p align="center">
  <img src="Resources/screenshot.png" width="600" alt="LoopSpaces Screenshot">
</p>

## 📦 Installation

### Download

- [Download the latest release](https://github.com/yourusername/LoopSpaces/releases/latest)
- Move LoopSpaces.app to your Applications folder

### From Source

```bash
git clone https://github.com/yourusername/LoopSpaces.git
cd LoopSpaces
open LoopSpaces.xcodeproj
```

Build and run the app from Xcode.

## 🔧 Usage

1. Launch LoopSpaces
2. Grant accessibility permissions when prompted
3. Press ⌘+` (or your custom hotkey) to bring up the spaces switcher
4. Navigate between spaces using arrows or by clicking on a space thumbnail
5. Press Enter to switch to the selected space, or Escape to cancel

## ⚙️ Technical Details

LoopSpaces is built using:

- SwiftUI for the user interface
- Combines AppKit and SwiftUI for bridging system functionality
- Uses Carbon APIs for global hotkey registration
- Implements private API calls to interact with macOS Spaces

**Note**: This app uses some private APIs to interact with Spaces. While it works with current macOS versions, future OS updates might affect compatibility.

## 🛣️ Roadmap

- [ ] Support for multiple displays
- [ ] Custom thumbnails for spaces
- [ ] Additional visual styles/themes
- [ ] Space renaming
- [ ] Keyboard shortcut for direct space access (e.g., ⌘+1 for Space 1)

## 🤝 Contributing

Contributions are welcome! Feel free to open issues and submit pull requests.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

LoopSpaces is available under the MIT license. See the [LICENSE](LICENSE) file for more info.
