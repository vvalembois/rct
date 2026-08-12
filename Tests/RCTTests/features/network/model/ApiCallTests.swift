import XCTest
@testable import RCT

final class ApiCallTests: XCTestCase {
    func testInitFromRequestMapsRequestFields() {
        var request = URLRequest(url: URL(string: "https://api.example.com/users?page=1")!)
        request.httpMethod = "POST"
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.timeoutInterval = 30
        request.allHTTPHeaderFields = ["Content-Type": "application/json"]
        request.httpBody = Data("{\"name\":\"John\"}".utf8)

        let call = ApiCall(request)

        XCTAssertEqual(call.requestURL, "https://api.example.com/users?page=1")
        XCTAssertEqual(call.requestMethod, "POST")
        XCTAssertEqual(call.requestCachePolicy, "ReloadIgnoringLocalCacheData")
        XCTAssertEqual(call.requestType, "application/json")
        XCTAssertEqual(call.requestShortType, .JSON)
        XCTAssertEqual(call.requestBody, "{\"name\":\"John\"}")
        XCTAssertEqual(call.requestBodyLength, 15)
        XCTAssertEqual(call.requestURLQueryItems?.first?.name, "page")
        XCTAssertEqual(call.requestURLQueryItems?.first?.value, "1")
        XCTAssertNotNil(call.requestDate)
        XCTAssertNotNil(call.requestTime)
    }

    func testSaveResponseMapsResponseFieldsAndBody() {
        let requestDate = Date(timeIntervalSince1970: 0)
        let call = ApiCall(
            requestURL: "https://api.example.com/users",
            requestDate: requestDate,
            requestType: "application/json",
            requestShortType: .JSON,
            noResponse: true
        )
        let response = HTTPURLResponse(
            url: URL(string: "https://api.example.com/users")!,
            statusCode: 201,
            httpVersion: nil,
            headerFields: ["Content-Type": "application/json; charset=utf-8"]
        )!

        call.saveResponse(response, data: Data("{\"ok\":true}".utf8))

        XCTAssertFalse(call.noResponse)
        XCTAssertEqual(call.responseStatus, 201)
        XCTAssertEqual(call.responseType, "application/json")
        XCTAssertEqual(call.responseShortType, .JSON)
        XCTAssertEqual(call.responseBody, "{\"ok\":true}")
        XCTAssertEqual(call.responseBodyLength, 11)
        XCTAssertNotNil(call.responseDate)
        XCTAssertNotNil(call.responseTime)
        XCTAssertNotNil(call.timeInterval)
    }

    func testSetToErrorResponseSetsResponseDate() {
        let call = ApiCall(requestURL: "https://api.example.com")

        call.setToErrorResponse()

        XCTAssertNotNil(call.responseDate)
    }

    func testEqualityUsesIdentity() {
        let call = ApiCall(requestURL: "https://api.example.com")
        let sameReference = call
        let differentInstance = ApiCall(requestURL: "https://api.example.com")

        XCTAssertEqual(call, sameReference)
        XCTAssertNotEqual(call, differentInstance)
    }
}
