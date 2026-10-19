import XCTest
@testable import RCT

final class LogFilterTests: XCTestCase {
    private let logs = [
        LogEntry(type: .info, message: "App started", time: 1, className: "App"),
        LogEntry(type: .warning, message: "Retrying request", time: 3, className: "UserService"),
        LogEntry(type: .error, message: "Decoding failed", time: 2, className: "DogAPI")
    ]

    func testResultsAreNewestFirst() {
        XCTAssertEqual(LogFilter.apply(logs, scope: .anyLevel, query: "").map(\.time), [3, 2, 1])
    }

    func testScopeFiltersByLevel() {
        XCTAssertEqual(LogFilter.apply(logs, scope: .info, query: "").map(\.type), [.info])
        XCTAssertEqual(LogFilter.apply(logs, scope: .warning, query: "").map(\.type), [.warning])
        XCTAssertEqual(LogFilter.apply(logs, scope: .error, query: "").map(\.type), [.error])
    }

    func testQueryMatchesMessageAndContext() {
        XCTAssertEqual(LogFilter.apply(logs, scope: .anyLevel, query: "decoding").count, 1)
        XCTAssertEqual(LogFilter.apply(logs, scope: .anyLevel, query: "userservice").count, 1)
        XCTAssertTrue(LogFilter.apply(logs, scope: .error, query: "started").isEmpty)
    }
}
