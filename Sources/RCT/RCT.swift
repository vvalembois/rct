//
//  RCT.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation
import SwiftUI

// swiftlint:disable:next type_name
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
        fileprivate var closeObserver: NSObjectProtocol?
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
    
    /// Enables network capture for sessions created from `configuration`.
    ///
    /// Sessions built from `URLSessionConfiguration.default` or `.ephemeral` after `start()`
    /// are captured automatically. Call this for configurations that are not created that way,
    /// or for sessions created before `start()`, before creating the `URLSession`
    /// (a session copies its configuration when it is created).
    ///
    /// ```swift
    /// let configuration = URLSessionConfiguration.default
    /// RCT.sharedInstance().enableCapture(on: configuration)
    /// let session = URLSession(configuration: configuration)
    /// ```
    public func enableCapture(on configuration: URLSessionConfiguration) {
        configuration.insertCaptureProtocol()
    }
    
    /// Called when the interface was dismissed by the system (swipe down on iOS, close button on macOS).
    @MainActor func didDismiss() {
        self.presented = false
        #if os(iOS)
        self.viewController = nil
        #elseif os(macOS)
        if let closeObserver {
            NotificationCenter.default.removeObserver(closeObserver)
        }
        self.closeObserver = nil
        self.window = nil
        #endif
    }
}

#if os(iOS)
@MainActor
extension RCT {
    
    private func openWindow() {
        let presenter = self.topViewController(UIApplication.shared.currentWindow?.rootViewController)
        let controller = UIHostingController(rootView: RootView())
        // iPad gets the whole screen for its three-column split view; iPhone uses a standard sheet.
        controller.modalPresentationStyle = UIDevice.current.userInterfaceIdiom == .pad ? .fullScreen : .pageSheet
        self.viewController = controller
        presenter?.present(controller, animated: true)
    }
    
    private func closeWindow() {
        self.viewController?.dismiss(animated: true)
        self.viewController = nil
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
    
    private static let windowAutosaveName = "RCTWindow"
    
    private func openWindow() {
        let controller = NSHostingController(rootView: RootView())
        // Lets SwiftUI drive the window toolbar and title (navigationTitle / navigationSubtitle).
        controller.sceneBridgingOptions = [.toolbars, .title]
        
        let window = NSWindow(contentViewController: controller)
        window.title = "RCT"
        window.styleMask = [.titled, .closable, .resizable, .miniaturizable, .fullSizeContentView]
        window.toolbarStyle = .unified
        window.isReleasedWhenClosed = false
        window.setContentSize(NSSize(width: 1200, height: 760))
        window.minSize = NSSize(width: 820, height: 520)
        if !window.setFrameUsingName(Self.windowAutosaveName) {
            window.center()
        }
        window.setFrameAutosaveName(Self.windowAutosaveName)
        
        // Keeps `presented` in sync when the window is closed with the close button.
        closeObserver = NotificationCenter.default.addObserver(
            forName: NSWindow.willCloseNotification,
            object: window,
            queue: .main
        ) { [weak self] _ in
            Task { @MainActor in
                self?.didDismiss()
            }
        }
        
        window.makeKeyAndOrderFront(nil)
        self.window = window
    }
    
    private func closeWindow() {
        self.window?.close()
    }
}
#endif
