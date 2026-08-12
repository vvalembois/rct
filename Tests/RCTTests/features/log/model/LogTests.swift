import XCTest
@testable import RCT

final class LogTests: XCTestCase {
    func testToStringIncludesTypeTimeAndMessage() {
        let log = LogEntry(type: .info, message: "Hello", time: 0, className: "Unit")

        let text = log.toString()

        XCTAssertTrue(text.contains("[Info]"))
        XCTAssertTrue(text.contains("Hello"))
    }

    func testGetImageReturnsExpectedSymbolName() {
        XCTAssertEqual(LogEntry(type: .info, message: "", time: 0, className: "").getImage(), "info.circle.fill")
        XCTAssertEqual(LogEntry(type: .error, message: "", time: 0, className: "").getImage(), "exclamationmark.circle.fill")
        XCTAssertEqual(LogEntry(type: .warning, message: "", time: 0, className: "").getImage(), "ladybug.circle.fill")
    }

    func testPersistableMappingRoundTrip() {
        let original = LogEntry(type: .warning, message: "payload", time: 12.34, className: "Class")

        let logDao: LogDao = original.managedObject()
        let recreated = LogEntry(managedObject: logDao)

        XCTAssertEqual(recreated.type, .warning)
        XCTAssertEqual(recreated.message, "payload")
        XCTAssertEqual(recreated.time, 12.34)
        XCTAssertEqual(recreated.className, "Class")
    }

    func testPersistableInitFallsBackToErrorForUnknownType() {
        let logDao = LogDao(type: "Unknown", message: "x", time: 1, className: "C")

        let log = LogEntry(managedObject: logDao)

        XCTAssertEqual(log.type, .error)
    }
}
