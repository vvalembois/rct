import XCTest
@testable import RCT
import RCTUI

final class LogTests: XCTestCase {
    func testToStringIncludesTypeTimeAndMessage() {
        let log = LogEntry(type: .info, message: "Hello", time: 0, className: "Unit")

        let text = log.toString()

        XCTAssertTrue(text.contains("[Info]"))
        XCTAssertTrue(text.contains("Hello"))
    }

    func testToneMatchesLevel() {
        XCTAssertEqual(LogEntry(type: .info, message: "", time: 0, className: "").tone, .info)
        XCTAssertEqual(LogEntry(type: .warning, message: "", time: 0, className: "").tone, .warning)
        XCTAssertEqual(LogEntry(type: .error, message: "", time: 0, className: "").tone, .critical)
    }

    func testContextFallsBackToApp() {
        XCTAssertEqual(LogEntry(type: .info, message: "", time: 0, className: "").contextText, "App")
        XCTAssertEqual(LogEntry(type: .info, message: "", time: 0, className: "Service").contextText, "Service")
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
