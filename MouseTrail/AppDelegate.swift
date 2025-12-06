import Cocoa

@main
class AppDelegate: NSObject, NSApplicationDelegate {
    var mainWindow: MouseTrailWindow?
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let frame = NSRect(x: 100, y: 100, width: 800, height: 600)
        mainWindow = MouseTrailWindow(frame: frame)
        mainWindow?.makeKeyAndOrderFront(self)
        
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}
