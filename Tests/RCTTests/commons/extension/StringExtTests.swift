import XCTest
@testable import RCT

final class StringExtTests: XCTestCase {
    func testGetTypeFromRecognizesJsonXmlHtmlImageAndOther() {
        XCTAssertEqual("application/json".getTypeFrom(), .JSON)
        XCTAssertEqual("application/vnd.api+json".getTypeFrom(), .JSON)
        XCTAssertEqual("application/xml".getTypeFrom(), .XML)
        XCTAssertEqual("text/html".getTypeFrom(), .HTML)
        XCTAssertEqual("image/png".getTypeFrom(), .IMAGE)
        XCTAssertEqual("application/octet-stream".getTypeFrom(), .OTHER)
    }

    func testToPrettyPrettyPrintsValidJson() {
        let compact = "{\"a\":1,\"b\":2}"

        let pretty = compact.toPretty()

        XCTAssertTrue(pretty.contains("\n"))
        XCTAssertTrue(pretty.contains("\"a\""))
        XCTAssertTrue(pretty.contains("\"b\""))
    }

    func testToPrettyReturnsOriginalForInvalidJson() {
        let invalid = "not-json"

        XCTAssertEqual(invalid.toPretty(), invalid)
    }

    func testMaskingSensitiveKeysMasksAssignedValues() {
        let source = "token=abc123&password = secret\napiKey: mykey"

        let masked = source.maskingSensitiveKeys(["token", "password", "apiKey"])

        XCTAssertTrue(masked.contains("token=****"))
        XCTAssertTrue(masked.contains("password = ****"))
        XCTAssertTrue(masked.contains("apiKey: ****"))
    }

    func testToImageReturnsNilForInvalidBase64() {
        XCTAssertNil("not-base64".toImage())
    }

    func testToImageCreatesImageFromValidBase64Png() {
        let onePixelPngBase64 = "iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/w8AAgMBAQEAAP8AAAAASUVORK5CYII="

        XCTAssertNotNil(onePixelPngBase64.toImage())
    }
}
