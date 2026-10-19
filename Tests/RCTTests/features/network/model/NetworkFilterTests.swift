import XCTest
@testable import RCT
import RCTUI

final class NetworkFilterTests: XCTestCase {
    private let calls = [
        ApiCall(requestURL: "https://api.example.com/v1/users", requestMethod: "POST", responseStatus: 201, noResponse: false),
        ApiCall(requestURL: "https://github.com/vvalembois", requestMethod: "GET", responseStatus: 304, noResponse: false),
        ApiCall(requestURL: "https://dog.ceo/api/breeds/x/random", requestMethod: "GET", responseStatus: 404, noResponse: false),
        ApiCall(requestURL: "https://api.example.com/v1/users/42", requestMethod: "PUT", responseStatus: 500, noResponse: false),
        ApiCall(requestURL: "https://api.exemple.com/data", requestMethod: "GET")
    ]

    func testScopesMatchStatusFamilies() {
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .anyStatus, query: "").count, 5)
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .success, query: "").map(\.responseStatus), [201])
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .redirect, query: "").map(\.responseStatus), [304])
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .clientError, query: "").map(\.responseStatus), [404])
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .serverError, query: "").map(\.responseStatus), [500])
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .failed, query: "").map(\.requestURL), ["https://api.exemple.com/data"])
    }

    func testQueryMatchesURLMethodAndStatus() {
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .anyStatus, query: "dog.ceo").count, 1)
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .anyStatus, query: "put").count, 1)
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .anyStatus, query: "404").count, 1)
        XCTAssertEqual(NetworkFilter.apply(calls, scope: .anyStatus, query: "  ").count, 5)
    }

    func testSummaryCountsFailures() {
        XCTAssertEqual(NetworkFilter.summary(calls), "5 requests · 2 failed")
        XCTAssertEqual(NetworkFilter.summary([calls[0]]), "1 request")
    }

    func testStatusPresentation() {
        XCTAssertEqual(calls[0].statusTone, .success)
        XCTAssertEqual(calls[1].statusTone, .notice)
        XCTAssertEqual(calls[2].statusTone, .warning)
        XCTAssertEqual(calls[3].statusTone, .critical)
        XCTAssertEqual(calls[4].statusTone, .critical)
        XCTAssertEqual(calls[4].statusCodeText, "Failed")
        XCTAssertEqual(calls[0].host, "api.example.com")
        XCTAssertEqual(calls[0].path, "/v1/users")
    }

    func testErrorResponseStoresMessageAndDuration() {
        let call = ApiCall(requestURL: "https://api.exemple.com/data", requestDate: Date(timeIntervalSinceNow: -2))
        call.setToErrorResponse(URLError(.cannotFindHost))

        XCTAssertNotNil(call.errorDescription)
        XCTAssertEqual(call.statusDescription, call.errorDescription)
        XCTAssertGreaterThanOrEqual(call.duration ?? 0, 1.9)
    }
}
