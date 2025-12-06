# Mouse Trail

A macOS application that adds a beautiful mouse trail effect to your cursor.

## Features

- **Real-time Mouse Tracking**: Tracks your mouse movement in real-time
- **Smooth Trail Animation**: Displays a smooth trail of circles that follow your cursor
- **Dynamic Size and Opacity**: The trail circles gradually increase in size and fade out with a smooth gradient
- **High Performance**: Uses Core Video Display Link for efficient 60 FPS rendering
- **Thread-Safe**: Implements proper thread-safe mechanisms for concurrent mouse tracking and rendering

## Build and Run

### Prerequisites

- macOS 12.0 or later
- Xcode 15.0 or later

### Building

1. Open `MouseTrail.xcodeproj` in Xcode
2. Select the "MouseTrail" scheme
3. Press Cmd+B to build

### Running

1. Press Cmd+R to run the application
2. Move your mouse over the window to see the trail effect
3. The trail consists of circles that gradually grow larger and fade out as they age

## Architecture

- **AppDelegate**: Application entry point and lifecycle management
- **MouseTrailWindow**: Custom NSWindow that hosts the trail view
- **MouseTrailView**: Core view that handles:
  - Mouse event tracking
  - Trail point storage and management
  - Rendering logic using NSBezierPath
  - Display link management for smooth animation

## Technical Details

### Mouse Tracking

The application uses NSTrackingArea to capture mouse movements with the following options:
- `.activeInKeyWindow`: Only track when the window is active
- `.mouseMoved`: Track all mouse movements
- `.inVisibleRect`: Update tracking rect automatically

### Rendering

- Uses CVDisplayLink to synchronize rendering with the display refresh rate
- Maintains a queue of trail points (max 30 points)
- Each point is rendered as a circle with increasing size and fading opacity
- Thread-safe point storage using NSLock

### Performance

- Display link callback runs at 60 FPS
- Efficient point queue management with automatic removal of old points
- Minimal memory overhead due to fixed trail length

## Customization

You can customize the trail by modifying the following parameters in `MouseTrailView.swift`:

- `maxTrailLength`: Maximum number of trail points (default: 30)
- `updateInterval`: Rendering interval in seconds (default: 0.016 for ~60 FPS)
- Trail color: Modify the RGB values in the `drawTrail` method
- Circle sizes: Adjust the size calculation in the drawing logic
