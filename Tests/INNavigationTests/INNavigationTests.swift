@testable import INNavigation
import XCTest

class INNavigationTests: XCTestCase {
	func testVersionNumber() {
		let version = INNavigationVersion.version
		XCTAssertEqual(1, version)
	}
}
