//
//  UIApplication.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

#if os(iOS)
import UIKit
#endif

extension UIApplication {
    var currentWindow: UIWindow? {
        // For apps supporting multiple scenes
        return self.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
    }
}
