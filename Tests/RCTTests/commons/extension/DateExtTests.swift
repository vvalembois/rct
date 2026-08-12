import XCTest
@testable import RCT

final class DateExtTests: XCTestCase {
    func testFormattedTimeUsesZeroPaddedMinutes() {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 9, minute: 5, second: 0, of: Date())!

        XCTAssertEqual(date.formattedTime(), "9:05")
    }

    func testFormattedTimeSupportsTwoDigitHour() {
        let calendar = Calendar.current
        let date = calendar.date(bySettingHour: 14, minute: 42, second: 0, of: Date())!

        XCTAssertEqual(date.formattedTime(), "14:42")
    }
}
