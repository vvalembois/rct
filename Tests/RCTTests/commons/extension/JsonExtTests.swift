import XCTest
@testable import RCT

private struct JsonFixture: Codable, Equatable {
    let id: Int
    let name: String
}

final class JsonExtTests: XCTestCase {
    func testAsJsonEncodesCodableType() {
        let fixture = JsonFixture(id: 1, name: "Vincent")

        let json = fixture.asJson()

        XCTAssertTrue(json.contains("\"id\":1"))
        XCTAssertTrue(json.contains("\"name\":\"Vincent\""))
    }

    func testDecodeFromJsonDecodesCodableType() {
        let json = "{\"id\":2,\"name\":\"RCT\"}"

        let decoded = json.decodeFromJson(type: JsonFixture.self)

        XCTAssertEqual(decoded, JsonFixture(id: 2, name: "RCT"))
    }

    func testDecodeFromJsonReturnsNilForInvalidJson() {
        let invalid = "{ id: 1, name: }"

        let decoded = invalid.decodeFromJson(type: JsonFixture.self)

        XCTAssertNil(decoded)
    }
}
