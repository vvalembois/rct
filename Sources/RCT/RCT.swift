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
    
    fileprivate var viewController: UIViewController?
    
    public func start() {
        self.started = true
        NetworkManager.shared.start()
    }
    
    public func stop() {
        self.started = false
        NetworkManager.shared.stop()
    }
    
    @MainActor public func motionDetected() {
        guard self.started else { return }
        toggleRCT()
    }
    
    @MainActor fileprivate func toggleRCT() {
        if self.presented {
            hideRCT()
        } else {
            showRCT()
        }
    }
    
    @MainActor fileprivate func hideRCT() {
        if !self.presented {
            return
        }
        self.presented = false
        self.viewController?.dismiss(animated: true)
    }
    
    fileprivate func showRCT() {
        if self.presented {
            return
        }
        self.presented = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) { [weak self] in
            guard let self = self else { return } // safe unwrap
            
            let currentViewController = self.topViewController(UIApplication.shared.currentWindow?.rootViewController)
            self.viewController = UIHostingController(rootView: TabBarView())
            
            // this tap gesture allows tabbaritem to be tappable
            let gesture = UITapGestureRecognizer(target: self, action: nil)
            gesture.cancelsTouchesInView = false
            self.viewController?.view.isUserInteractionEnabled = true
            self.viewController?.view.addGestureRecognizer(gesture)

            currentViewController?.present(self.viewController ?? UINavigationController(), animated: true, completion: nil)
        }
    }
    
    @MainActor private func topViewController(_ controller: UIViewController?) -> UIViewController? {
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
