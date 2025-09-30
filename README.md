![RCT – Debug & Testing Module  ](./readme/images/banner.png)

![Swift](https://img.shields.io/badge/Swift-6.0-orange?logo=swift&logoColor=white)
![iOS](https://img.shields.io/badge/iOS-15%2B-blue?logo=apple&logoColor=white)
![SPM](https://img.shields.io/badge/SPM-compatible-green)
![License](https://img.shields.io/badge/License-MIT-blue)

The goal of this Swift Package is to provide testers with a module that offers useful information in case of issues with the application.  

This module allows testers to access:  
- 📊 Application and device information  
- 📝 Application logs  
- 🌐 Network requests and their details  


## Environment & Compatibility  

- Xcode **26.0.1**  
- Swift **6+**  
- iOS **15**  

## Screenshots  

| Info | Logs | Network | Network Detail | Response Detail |
|------|------|---------|----------------|-----------------|
| <img src="./readme/images/info_dark.png" width="200" /> | <img src="./readme/images/log_dark.png" width="200" /> | <img src="./readme/images/network_dark.png" width="200" /> | <img src="./readme/images/network_detail_dark.png" width="200" /> | <img src="./readme/images/network_detail_response_dark.png" width="200" /> |


## Installation  

The [Swift Package Manager] is a tool that automates the distribution of Swift code and is integrated into the `swift` compiler.  

Once your Swift package is configured, adding **RCT** as a dependency is as simple as adding it to the `dependencies` section of your `Package.swift`:  

```swift
dependencies: [
    .package(url: "https://github.com/vvalembois/help-review", from: "1.0.0")
]
```

## Usage

```swift
import SwiftUI
import RCT

@main
struct TestSwiftUIApp: App {
    
    @Environment(\.scenePhase) var scenePhase
    
    var body: some Scene {
        WindowGroup {
            Text("Hey !!")
                .onAppear {
                    #if DEV
                        RCT.sharedInstance().start()
                    #endif
                    rct_log(.info, message: "Text onAppear")
                }
        }
    }
}
```

## Triggering the Module  

To display the **RCT Debug Module** during your testing session, you can trigger by **shake** the iPhone.

## 👨‍💻 Author

Vincent Valembois