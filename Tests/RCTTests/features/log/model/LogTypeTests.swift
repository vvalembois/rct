import XCTest
@testable import RCT

final class LogTypeTests: XCTestCase {
    func testRawValuesMatchExpectedLabels() {
        XCTAssertEqual(LogEntryType.info.rawValue, "Info")
        XCTAssertEqual(LogEntryType.warning.rawValue, "Warning")
        XCTAssertEqual(LogEntryType.error.rawValue, "Error")
    }

    func testCodableRoundTripPreservesValue() throws {
        let value = LogEntryType.warning

        let data = try JSONEncoder().encode(value)
        let decoded = try JSONDecoder().decode(LogEntryType.self, from: data)

        XCTAssertEqual(decoded, value)
    }
}
