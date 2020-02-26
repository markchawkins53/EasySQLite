import XCTest
@testable import EasySQLite

final class EasySQLiteTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(EasySQLite().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
