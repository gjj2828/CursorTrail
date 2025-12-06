import Cocoa

class MouseTrailView: NSView {
    private var trailPoints: [NSPoint] = []
    private let maxTrailLength = 30
    private let updateInterval = 0.016 // ~60 FPS
    private var displayLink: CVDisplayLink?
    private let lock = NSLock()
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        setupDisplayLink()
        setupMouseTracking()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        stopDisplayLink()
    }
    
    private func setupMouseTracking() {
        let trackingArea = NSTrackingArea(
            rect: bounds,
            options: [.activeInKeyWindow, .mouseEnteredAndExited, .mouseMoved, .inVisibleRect],
            owner: self,
            userInfo: nil
        )
        addTrackingArea(trackingArea)
    }
    
    private func setupDisplayLink() {
        var displayLink: CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplay(&displayLink)
        
        guard let displayLink = displayLink else { return }
        
        let output: CVDisplayLinkOutputCallback = { (displayLink, inNow, inOutputTime, flagsIn, flagsOut, displayLinkContext) -> CVReturn in
            let view = Unmanaged<MouseTrailView>.fromOpaque(displayLinkContext!).takeUnretainedValue()
            DispatchQueue.main.async {
                view.needsDisplay = true
            }
            return kCVReturnSuccess
        }
        
        CVDisplayLinkSetOutputCallback(displayLink, output, Unmanaged.passUnretained(self).toOpaque())
        CVDisplayLinkStart(displayLink)
        self.displayLink = displayLink
    }
    
    private func stopDisplayLink() {
        guard let displayLink = displayLink else { return }
        CVDisplayLinkStop(displayLink)
    }
    
    override func mouseMoved(with event: NSEvent) {
        let location = convert(event.locationInWindow, from: nil)
        lock.lock()
        trailPoints.append(location)
        if trailPoints.count > maxTrailLength {
            trailPoints.removeFirst()
        }
        lock.unlock()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        NSColor.white.setFill()
        dirtyRect.fill()
        
        lock.lock()
        let pointsToDraw = trailPoints
        lock.unlock()
        
        drawTrail(pointsToDraw)
    }
    
    private func drawTrail(_ points: [NSPoint]) {
        if points.isEmpty {
            return
        }
        
        let path = NSBezierPath()
        
        for (index, point) in points.enumerated() {
            let alpha = CGFloat(index) / CGFloat(max(1, points.count - 1))
            let size = 2.0 + (8.0 * alpha)
            
            let circle = NSBezierPath(ovalIn: NSRect(
                x: point.x - size / 2,
                y: point.y - size / 2,
                width: size,
                height: size
            ))
            
            let color = NSColor(
                red: 0.2,
                green: 0.4,
                blue: 0.8,
                alpha: alpha * 0.8
            )
            color.setFill()
            circle.fill()
        }
    }
}
