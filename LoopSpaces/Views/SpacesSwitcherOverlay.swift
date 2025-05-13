import SwiftUI

/// The main overlay view for the spaces switcher
struct SpacesSwitcherOverlay: View {
    @ObservedObject var spacesService: SpacesService
    @State private var selectedIndex: Int = 0
    var onSpaceSelected: (Space) -> Void
    var onDismiss: () -> Void
    
    init(spacesService: SpacesService, onSpaceSelected: @escaping (Space) -> Void, onDismiss: @escaping () -> Void) {
        print("SpacesSwitcherOverlay initializing...")
        self.spacesService = spacesService
        self.onSpaceSelected = onSpaceSelected
        self.onDismiss = onDismiss
    }
    
    var body: some View {
        VStack {
            // App title and logo
            HStack {
                Image(systemName: "square.grid.3x2.fill")
                    .font(.system(size: 22))
                    .foregroundColor(.white)
                
                Text("LoopSpaces")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.white)
            }
            .padding(.top, 10)
            
            // Spaces carousel
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 20) {
                    ForEach(Array(spacesService.spaces.enumerated()), id: \.element.id) { index, space in
                        SpaceThumbnail(
                            space: space,
                            isSelected: selectedIndex == index,
                            onSelect: {
                                print("Space \(space.id) selected")
                                selectedIndex = index
                                onSpaceSelected(space)
                            }
                        )
                    }
                }
                .padding(.horizontal, 30)
                .padding(.vertical, 20)
            }
            
            // Keyboard control hints
            HStack(spacing: 16) {
                KeyCapView(symbol: "arrow.left")
                Text("Previous")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                KeyCapView(symbol: "arrow.right")
                Text("Next")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                KeyCapView(symbol: "return")
                Text("Switch")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                
                KeyCapView(symbol: "escape")
                Text("Cancel")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
            }
            .padding(.bottom, 10)
        }
        .padding()
        .frame(width: 800, height: 300)
        .background(
            ZStack {
                // Blurred background
                Color.black.opacity(0.2)
                
                // Gradient overlay for depth
                LinearGradient(
                    gradient: Gradient(colors: [Color.blue.opacity(0.1), Color.purple.opacity(0.1)]),
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .background(.ultraThinMaterial)
            .cornerRadius(24)
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .strokeBorder(LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.4), Color.white.opacity(0.1)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
            )
        )
        .onAppear {
            print("SpacesSwitcherOverlay appeared, spaces count: \(spacesService.spaces.count)")
            // Find the currently active space and select it
            if let activeIndex = spacesService.spaces.firstIndex(where: { $0.isActive }) {
                selectedIndex = activeIndex
                print("Active space selected: \(activeIndex)")
            } else {
                print("No active space found")
            }
        }
        .onKeyPress { press in
            print("Key pressed: \(press.key)")
            switch press.key {
            case .leftArrow:
                selectPreviousSpace()
                return .handled
            case .rightArrow:
                selectNextSpace()
                return .handled
            case .return:
                if let space = currentlySelectedSpace {
                    print("Enter pressed, selecting space \(space.id)")
                    onSpaceSelected(space)
                }
                return .handled
            case .escape:
                print("Escape pressed, dismissing overlay")
                onDismiss()
                return .handled
            default:
                return .ignored
            }
        }
    }
    
    private var currentlySelectedSpace: Space? {
        guard selectedIndex >= 0 && selectedIndex < spacesService.spaces.count else {
            return nil
        }
        return spacesService.spaces[selectedIndex]
    }
    
    private func selectNextSpace() {
        let nextIndex = (selectedIndex + 1) % spacesService.spaces.count
        print("Selecting next space: \(nextIndex)")
        selectedIndex = nextIndex
    }
    
    private func selectPreviousSpace() {
        let prevIndex = (selectedIndex - 1 + spacesService.spaces.count) % spacesService.spaces.count
        print("Selecting previous space: \(prevIndex)")
        selectedIndex = prevIndex
    }
}

/// A view for displaying a keyboard key with an icon
struct KeyCapView: View {
    let symbol: String
    
    var body: some View {
        Image(systemName: symbol)
            .font(.system(size: 10, weight: .bold))
            .foregroundColor(.white)
            .frame(width: 24, height: 24)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(Color.white.opacity(0.2))
            )
    }
}

#Preview {
    ZStack {
        Color.black
            .edgesIgnoringSafeArea(.all)
        
        SpacesSwitcherOverlay(
            spacesService: SpacesService(),
            onSpaceSelected: { _ in },
            onDismiss: {}
        )
    }
} 