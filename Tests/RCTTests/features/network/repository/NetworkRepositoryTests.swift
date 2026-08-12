import XCTest
@testable import RCT

final class NetworkRepositoryTests: XCTestCase {
    func testAddInsertsNewestAtBeginning() {
        let repository = NetworkRepository()
        repository.clear()

        let first = ApiCall(requestURL: "https://api.example.com/first")
        let second = ApiCall(requestURL: "https://api.example.com/second")

        repository.add(first)
        repository.add(second)

        XCTAssertEqual(repository.calls.count, 2)
        XCTAssertEqual(repository.calls.first?.requestURL, "https://api.example.com/second")
        XCTAssertEqual(repository.calls.last?.requestURL, "https://api.example.com/first")
    }

    func testClearRemovesAllCalls() {
        let repository = NetworkRepository()
        repository.add(ApiCall(requestURL: "https://api.example.com"))

        repository.clear()

        XCTAssertTrue(repository.calls.isEmpty)
    }
}
