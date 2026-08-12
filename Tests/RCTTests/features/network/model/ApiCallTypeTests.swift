import XCTest
@testable import RCT

final class ApiCallTypeTests: XCTestCase {
    func testRawValuesAreStable() {
        XCTAssertEqual(ApiCallType.JSON.rawValue, "JSON")
        XCTAssertEqual(ApiCallType.XML.rawValue, "XML")
        XCTAssertEqual(ApiCallType.HTML.rawValue, "HTML")
        XCTAssertEqual(ApiCallType.IMAGE.rawValue, "Image")
        XCTAssertEqual(ApiCallType.OTHER.rawValue, "Other")
    }
}
