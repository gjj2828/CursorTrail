import Cocoa

class ContentView: NSView {
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        
        NSColor.white.setFill()
        dirtyRect.fill()
    }
}
