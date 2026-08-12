import Foundation
import XCTest
@testable import RCT

final class InputStreamExtTests: XCTestCase {
    func testReadfullyReadsAllBytes() {
        let payload = "hello world".data(using: .utf8)!
        let stream = InputStream(data: payload)

        let read = stream.readfully()

        XCTAssertEqual(read, payload)
    }

    func testReadfullyHandlesEmptyInput() {
        let payload = Data()
        let stream = InputStream(data: payload)

        let read = stream.readfully()

        XCTAssertTrue(read.isEmpty)
    }
}
