import XCTest
@testable import RCT

final class DictionaryExtTests: XCTestCase {
    func testMaskingSensitiveKeysMasksCaseInsensitively() {
        let headers = [
            "Authorization": "Bearer token",
            "Content-Type": "application/json"
        ]

        let masked = headers.maskingSensitiveKeys(["authorization"])

        XCTAssertEqual(masked["Authorization"], "****")
        XCTAssertEqual(masked["Content-Type"], "application/json")
    }

    func testMaskingSensitiveKeysLeavesUnknownKeysUntouched() {
        let source = ["A": "1", "B": "2"]

        let masked = source.maskingSensitiveKeys(["C"])

        XCTAssertEqual(masked, source)
    }
}
