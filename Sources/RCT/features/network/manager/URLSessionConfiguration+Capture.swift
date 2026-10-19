//
//  URLSessionConfiguration+Capture.swift
//  RCT
//
//  Created by Vincent Valembois on 19/10/2026.
//

import Foundation
import ObjectiveC

/// Makes every session created from `URLSessionConfiguration.default` or `.ephemeral`
/// go through `NetworkProtocol`, not only `URLSession.shared`.
///
/// `URLProtocol.registerClass` only applies to `URLSession.shared`: sessions created with
/// `URLSession(configuration:)` (custom API clients, Alamofire, Moya…) copy the
/// `protocolClasses` of their configuration and ignore registered classes.
/// The two configuration factories are swizzled once so `NetworkProtocol` is inserted first.
/// Capture still depends on `RCT.start()`: `NetworkProtocol` ignores requests while RCT is stopped.
enum URLSessionConfigurationCapture {

    /// Swizzles the configuration factories. Thread-safe and idempotent.
    static func install() {
        _ = installation
    }

    private static let installation: Void = {
        exchangeClassMethod(
            original: NSSelectorFromString("defaultSessionConfiguration"),
            swizzled: #selector(URLSessionConfiguration.rctDefaultSessionConfiguration)
        )
        exchangeClassMethod(
            original: NSSelectorFromString("ephemeralSessionConfiguration"),
            swizzled: #selector(URLSessionConfiguration.rctEphemeralSessionConfiguration)
        )
    }()

    private static func exchangeClassMethod(original: Selector, swizzled: Selector) {
        guard
            let originalMethod = class_getClassMethod(URLSessionConfiguration.self, original),
            let swizzledMethod = class_getClassMethod(URLSessionConfiguration.self, swizzled)
        else {
            return
        }
        method_exchangeImplementations(originalMethod, swizzledMethod)
    }
}

extension URLSessionConfiguration {

    /// After the exchange, calling this method runs the original `defaultSessionConfiguration`.
    @objc dynamic class func rctDefaultSessionConfiguration() -> URLSessionConfiguration {
        let configuration = rctDefaultSessionConfiguration()
        configuration.insertCaptureProtocol()
        return configuration
    }

    /// After the exchange, calling this method runs the original `ephemeralSessionConfiguration`.
    @objc dynamic class func rctEphemeralSessionConfiguration() -> URLSessionConfiguration {
        let configuration = rctEphemeralSessionConfiguration()
        configuration.insertCaptureProtocol()
        return configuration
    }

    /// Inserts `NetworkProtocol` first in `protocolClasses` (no-op if already present).
    func insertCaptureProtocol() {
        var classes = protocolClasses ?? []
        guard !classes.contains(where: { ObjectIdentifier($0) == ObjectIdentifier(NetworkProtocol.self) }) else { return }
        classes.insert(NetworkProtocol.self, at: 0)
        protocolClasses = classes
    }

    /// Removes `NetworkProtocol` from `protocolClasses`.
    func removeCaptureProtocol() {
        protocolClasses = protocolClasses?.filter { ObjectIdentifier($0) != ObjectIdentifier(NetworkProtocol.self) }
    }
}
