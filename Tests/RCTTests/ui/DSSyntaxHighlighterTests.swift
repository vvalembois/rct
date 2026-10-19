import XCTest
@testable import RCTUI

final class DSSyntaxHighlighterTests: XCTestCase {
    func testJSONTokensDistinguishKeysStringsNumbersAndLiterals() {
        let tokens = DSSyntaxHighlighter.jsonTokens(in: #"{"name": "John", "age": 42, "score": -1.5e3, "verified": false, "tags": null}"#)

        XCTAssertEqual(tokens, [
            .init(kind: .key, text: #""name""#),
            .init(kind: .string, text: #""John""#),
            .init(kind: .key, text: #""age""#),
            .init(kind: .number, text: "42"),
            .init(kind: .key, text: #""score""#),
            .init(kind: .number, text: "-1.5e3"),
            .init(kind: .key, text: #""verified""#),
            .init(kind: .literal, text: "false"),
            .init(kind: .key, text: #""tags""#),
            .init(kind: .literal, text: "null")
        ])
    }

    func testNumbersAndLiteralsInsideStringsAreNotTokenized() {
        let tokens = DSSyntaxHighlighter.jsonTokens(in: #"{"text": "true 42 \"quoted\""}"#)

        XCTAssertEqual(tokens.map(\.kind), [.key, .string])
    }

    func testHighlightKeepsTheOriginalText() {
        let text = #"{"id": 1}"#

        XCTAssertEqual(String(DSSyntaxHighlighter.highlightJSON(text).characters), text)
    }
}
