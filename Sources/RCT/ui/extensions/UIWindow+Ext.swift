//
//  UIWindow+Ext.swift
//  RCT
//
//  Created by Vincent Valembois on 28/09/2025.
//

import Foundation

#if os(iOS)
import UIKit
#endif

extension UIWindow {
    override open func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
        if (event!.type == .motion && event!.subtype == .motionShake) {
            RCT.sharedInstance().motionDetected()
        }
        super.motionEnded(motion, with: event)
    }
}
