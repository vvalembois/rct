import XCTest
@testable import RCT

final class LogRepositoryTests: XCTestCase {
    private let key = "logs_key"

    override func setUp() {
        super.setUp()
        UserDefaults.standard.removeObject(forKey: key)
    }

    override func tearDown() {
        UserDefaults.standard.removeObject(forKey: key)
        super.tearDown()
    }

    func testAddLogAppendsAndClearRemovesAll() {
        let repository = LogRepository()
        let item = LogEntry(type: .info, message: "m", time: 2, className: "A")

        repository.addLog(item)

        XCTAssertEqual(repository.logs.count, 1)
        XCTAssertEqual(repository.logs.first?.message, "m")

        repository.clear()

        XCTAssertTrue(repository.logs.isEmpty)
    }

    func testLogsAreLoadedFromUserDefaultsOnInit() throws {
        let seeded = [LogEntry(type: .warning, message: "seed", time: 9, className: "Seed")]
        let data = try JSONEncoder().encode(seeded)
        UserDefaults.standard.set(data, forKey: key)

        let repository = LogRepository()

        XCTAssertEqual(repository.logs.count, 1)
        XCTAssertEqual(repository.logs.first?.message, "seed")
        XCTAssertEqual(repository.logs.first?.type, .warning)
    }
}
