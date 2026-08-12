import XCTest
@testable import RCT

final class NetworkManagerTests: XCTestCase {
    func testSensitiveKeysStartsEmptyAndIsMutable() {
        let manager = NetworkManager.shared
        manager.sensitiveKeys = []

        XCTAssertTrue(manager.sensitiveKeys.isEmpty)

        manager.sensitiveKeys = ["Authorization", "token"]

        XCTAssertEqual(manager.sensitiveKeys, ["Authorization", "token"])
    }

    func testClearDelegatesToRepository() {
        let manager = NetworkManager.shared
        NetworkRepository.shared.clear()
        NetworkRepository.shared.add(ApiCall(requestURL: "https://api.example.com"))
        XCTAssertEqual(NetworkRepository.shared.calls.count, 1)

        manager.clear()

        XCTAssertTrue(NetworkRepository.shared.calls.isEmpty)
    }

    func testGetLogsInStringReturnsEmptyString() {
        XCTAssertEqual(NetworkManager.shared.getLogsInString(), "")
    }
}
