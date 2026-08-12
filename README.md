![RCT - Debug & Testing Module](./readme/images/banner.png)

![Swift](https://img.shields.io/badge/Swift-6.1-orange?logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-16%2B-blue?logo=apple&logoColor=white)
![macOS](https://img.shields.io/badge/macOS-14%2B-blue?logo=apple&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-compatible-green)
![License](https://img.shields.io/badge/License-MIT-blue)

RCT is a Swift package designed to support functional debugging during test phases.
It centralizes helpful screens so you can quickly understand what is happening in the app.

Main features:
- Device and application information
- Application logs through a simple API
- Network request/response inspection

## Compatibility

- Swift 6.1+
- iOS 16+
- macOS 14+
- Xcode 16+

## Screenshots

| Info | Logs | Network | Network Detail | Response Detail |
|------|------|---------|----------------|-----------------|
| <img src="./readme/images/info_dark.png" width="200" /> | <img src="./readme/images/log_dark.png" width="200" /> | <img src="./readme/images/network_dark.png" width="200" /> | <img src="./readme/images/network_detail_dark.png" width="200" /> | <img src="./readme/images/network_detail_response_dark.png" width="200" /> |

## Installation (Swift Package Manager)

Add the package to your Package.swift:

```swift
dependencies: [
    .package(url: "https://github.com/vvalembois/help-review", from: "1.0.0")
]
```

Then add RCT to your target dependencies:

```swift
.target(
    name: "MyApp",
    dependencies: [
        .product(name: "RCT", package: "help-review")
    ]
)
```

## Quick Start

```swift
import SwiftUI
import RCT

@main
struct DemoApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .onAppear {
                    #if DEBUG
                    RCT.sharedInstance().start()
                    #endif

                    rct_log(.info, message: "App started")
                }
        }
    }
}
```

## Usage

- Open/Close the module:
    - iOS: shake the device
    - Programmatic: RCT.sharedInstance().toggleRCT()
- Stop network capture:
    - RCT.sharedInstance().stop()
- Define sensitive keys to mask:
    - RCT.sharedInstance().setSensitiveKeys(["authorization", "token", "password"])

## Useful Public API

- RCT.sharedInstance().start()
- RCT.sharedInstance().stop()
- RCT.sharedInstance().showRCT()
- RCT.sharedInstance().hideRCT()
- RCT.sharedInstance().toggleRCT()
- RCT.sharedInstance().setSensitiveKeys(_:)
- rct_log(_:context:message:)

## Tests

Run all unit tests:

```bash
swift test
```

Tests are located in:
- Tests/RCTTests

## Project Structure

- Sources/RCT/commons: shared utilities and extensions
- Sources/RCT/features/information: app/device information screen
- Sources/RCT/features/log: logs, models, repository, UI
- Sources/RCT/features/network: network capture, models, manager, repository, UI
- Tests/RCTTests: unit tests

## Author

Vincent Valembois
