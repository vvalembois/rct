import XCTest
@testable import RCTUI

final class DSFormatTests: XCTestCase {
    func testDurationUsesMillisecondsBelowOneSecond() {
        XCTAssertEqual(DSFormat.duration(0.374), "374 ms")
        XCTAssertEqual(DSFormat.duration(0), "0 ms")
    }

    func testDurationUsesSecondsFromOneSecond() {
        XCTAssertEqual(DSFormat.duration(1.24), "1.24 s")
    }

    func testDurationPlaceholderForMissingOrInvalidValues() {
        XCTAssertEqual(DSFormat.duration(nil), DSFormat.placeholder)
        XCTAssertEqual(DSFormat.duration(-1), DSFormat.placeholder)
        XCTAssertEqual(DSFormat.duration(.infinity), DSFormat.placeholder)
    }

    func testTimeIsTwentyFourHoursWithMilliseconds() {
        var components = DateComponents()
        components.year = 2025
        components.month = 10
        components.day = 4
        components.hour = 15
        components.minute = 8
        components.second = 12
        components.nanosecond = 250_000_000
        let date = Calendar.current.date(from: components)

        XCTAssertEqual(DSFormat.time(date), "15:08:12.250")
        XCTAssertEqual(DSFormat.time(date, milliseconds: false), "15:08:12")
        XCTAssertEqual(DSFormat.time(nil), DSFormat.placeholder)
    }

    func testHTTPStatusIncludesReason() {
        XCTAssertTrue(DSFormat.httpStatus(404).hasPrefix("404 "))
        XCTAssertEqual(DSFormat.httpStatus(201), "201 Created")
    }

    func testByteCountPlaceholderForMissingValue() {
        XCTAssertEqual(DSFormat.byteCount(nil), DSFormat.placeholder)
        XCTAssertFalse(DSFormat.byteCount(1_214).isEmpty)
    }
}
