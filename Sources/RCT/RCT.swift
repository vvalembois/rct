//
//  RecetteManager.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import SwiftUI

public class RCT: @unchecked Sendable {
    
    static let shared: RCT = .init()
    
    static public func sharedInstance() -> RCT {
        return Self.shared
    }
    
    var started: Bool = false

    fileprivate var presented: Bool = false
    
    #if os(iOS)
        fileprivate var viewController: UIViewController?
    #elseif os(macOS)
        fileprivate var window: NSWindow?
    #endif
    
    
    @MainActor public func start() {
        self.started = true
        NetworkManager.shared.start()
    }
    
    @MainActor public func stop() {
        self.started = false
        NetworkManager.shared.stop()
    }
    
    @MainActor public func motionDetected() {
        guard self.started else { return }
        toggleRCT()
    }
    
    @MainActor public func toggleRCT() {
        if self.presented {
            hideRCT()
        } else {
            showRCT()
        }
    }
    
    @MainActor public func hideRCT() {
        if !self.presented {
            return
        }
        self.presented = false
        closeWindow()
    }
    
    @MainActor public func showRCT() {
        if self.presented {
            return
        }
        self.presented = true
        openWindow()
    }
    
    public func setSensitiveKeys(_ sensitiveKeys: [String]) {
        NetworkManager.shared.sensitiveKeys = sensitiveKeys
    }
}

#if os(iOS)
@MainActor
extension RCT {
    
    private func closeWindow() {
        self.viewController?.dismiss(animated: true)
    }
    
    private func openWindow() {
        let currentViewController = self.topViewController(UIApplication.shared.currentWindow?.rootViewController)
        self.viewController = UIHostingController(rootView: TabBarView())
        
        let gesture = UITapGestureRecognizer(target: self, action: nil)
        gesture.cancelsTouchesInView = false
        self.viewController?.view.isUserInteractionEnabled = true
        self.viewController?.view.addGestureRecognizer(gesture)

        currentViewController?.present(self.viewController ?? UINavigationController(), animated: true, completion: nil)
    }
    
    private func topViewController(_ controller: UIViewController?) -> UIViewController? {
        if let navigationController = controller as? UINavigationController {
            return topViewController(navigationController.visibleViewController)
        } else if let tabController = controller as? UITabBarController {
            if let selected = tabController.selectedViewController {
                return topViewController(selected)
            }
        } else if let presented = controller?.presentedViewController {
            return topViewController(presented)
        }
        return controller
    }
}
#elseif os(macOS)
import AppKit

@MainActor
extension RCT {
    
    private func openWindow() {
        let contentView = NSHostingController(rootView: SplitView())
        
        let window = NSWindow(
            contentViewController: contentView
        )

        window.setContentSize(NSSize(width: 800, height: 600))
        window.center()
        
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.toolbarStyle = .unified
        window.isMovableByWindowBackground = true

        window.styleMask = [
            .titled,
            .closable,
            .resizable,
            .miniaturizable,
            .fullSizeContentView
        ]
        
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
    
    private func closeWindow() {
        self.window?.close()
        self.window = nil
    }
}
#endif
