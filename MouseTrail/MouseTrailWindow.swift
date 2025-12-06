import Cocoa

class MouseTrailWindow: NSWindow {
    private let trailView: MouseTrailView
    
    override init(contentRect: NSRect, styleMask style: NSWindow.StyleMask, backing backingStoreType: NSWindow.BackingStoreType, defer flag: Bool) {
        self.trailView = MouseTrailView(frame: contentRect)
        
        super.init(contentRect: contentRect, styleMask: [.titled, .closable, .miniaturizable, .resizable], backing: .buffered, defer: flag)
        
        self.title = "Mouse Trail"
        self.contentView = trailView
        self.isOpaque = false
        self.backgroundColor = NSColor.white
        self.level = .normal
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
