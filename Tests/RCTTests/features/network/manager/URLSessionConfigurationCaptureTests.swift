import XCTest
@testable import RCT

final class URLSessionConfigurationCaptureTests: XCTestCase {

    private func containsCaptureProtocol(_ configuration: URLSessionConfiguration) -> Bool {
        (configuration.protocolClasses ?? []).contains { ObjectIdentifier($0) == ObjectIdentifier(NetworkProtocol.self) }
    }

    func testDefaultAndEphemeralConfigurationsIncludeCaptureProtocolAfterInstall() {
        URLSessionConfigurationCapture.install()

        XCTAssertTrue(containsCaptureProtocol(.default))
        XCTAssertTrue(containsCaptureProtocol(.ephemeral))
        XCTAssertEqual(ObjectIdentifier(URLSessionConfiguration.default.protocolClasses!.first!), ObjectIdentifier(NetworkProtocol.self))
    }

    func testInstallIsIdempotent() {
        URLSessionConfigurationCapture.install()
        URLSessionConfigurationCapture.install()

        let count = (URLSessionConfiguration.default.protocolClasses ?? [])
            .filter { ObjectIdentifier($0) == ObjectIdentifier(NetworkProtocol.self) }
            .count
        XCTAssertEqual(count, 1)
    }

    func testEnableCaptureInsertsProtocolOnce() {
        let configuration = URLSessionConfiguration.default
        configuration.removeCaptureProtocol()
        XCTAssertFalse(containsCaptureProtocol(configuration))

        RCT.sharedInstance().enableCapture(on: configuration)
        RCT.sharedInstance().enableCapture(on: configuration)

        let count = (configuration.protocolClasses ?? [])
            .filter { ObjectIdentifier($0) == ObjectIdentifier(NetworkProtocol.self) }
            .count
        XCTAssertEqual(count, 1)
    }
}
