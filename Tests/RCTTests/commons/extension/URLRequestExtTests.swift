import Foundation
import XCTest
@testable import RCT

final class URLRequestExtTests: XCTestCase {
    func testGetCachePolicyMapsKnownValues() {
        var request = URLRequest(url: URL(string: "https://example.com")!)

        request.cachePolicy = .reloadIgnoringLocalCacheData
        XCTAssertEqual(request.getCachePolicy(), "ReloadIgnoringLocalCacheData")

        request.cachePolicy = .returnCacheDataElseLoad
        XCTAssertEqual(request.getCachePolicy(), "ReturnCacheDataElseLoad")
    }

    func testGetURLComponentsParsesURLAndQueryItems() {
        let url = URL(string: "https://example.com/path?q=swift&sort=asc")!
        let request = URLRequest(url: url)

        let components = request.getURLComponents()

        XCTAssertEqual(components?.host, "example.com")
        XCTAssertEqual(components?.path, "/path")
        XCTAssertEqual(components?.queryItems?.count, 2)
    }

    func testGetBodyReadsFromHttpBodyStream() {
        let data = "stream-body".data(using: .utf8)!
        var request = URLRequest(url: URL(string: "https://example.com")!)
        request.httpBodyStream = InputStream(data: data)

        XCTAssertEqual(request.getBody(), data)
    }

    func testGetBodyFallsBackToBodyDataProperty() {
        let data = "fallback-body".data(using: .utf8)!
        let mutableRequest = NSMutableURLRequest(url: URL(string: "https://example.com")!)
        URLProtocol.setProperty(data, forKey: "BodyData", in: mutableRequest)
        let request = mutableRequest as URLRequest

        XCTAssertEqual(request.getBody(), data)
    }
}
