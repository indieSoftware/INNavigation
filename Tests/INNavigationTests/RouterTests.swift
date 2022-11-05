@testable import INNavigation
import SwiftUI
import XCTest

@MainActor
final class RouterTests: XCTestCase {
	// MARK: - Init

	func testInitProvidesRoot() throws {
		let sut = Router(root: .testRoute1)

		let result = sut.paths

		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.routes.count, 0)
		XCTAssertEqual(path.root, .testRoute1)
	}

	// MARK: - NumberOfPushedViews

	func testNumberOfPushedViewsOnEmptyPath() {
		let sut = Router(root: .testRoute1)
		let result = sut.numberOfPushedViews
		XCTAssertEqual(result, 0)
	}

	func testNumberOfPushedViewsOnExistingPath() {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)
		let result = sut.numberOfPushedViews
		XCTAssertEqual(result, 2)
	}

	// MARK: - NumberOfPresentedViews

	func testNumberOfPresentedViewsOnSinglePath() {
		let sut = Router(root: .testRoute1)
		let result = sut.numberOfPresentedViews
		XCTAssertEqual(result, 1)
	}

	func testNumberOfPresentedViewsOnMultiplePaths() {
		let sut = Router(root: .testRoute1)
		sut.applyPresent(.testRoute2)
		sut.applyPresent(.testRoute3)
		let result = sut.numberOfPresentedViews
		XCTAssertEqual(result, 3)
	}

	// MARK: - Set

	func testSetWithOnePath() throws {
		let sut = Router(root: .testRoute1)

		sut.applySet(routes: [Route.testRoute2])

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	func testSetWithMultiplePaths() throws {
		let sut = Router(root: .testRoute1)

		sut.applySet(routes: [Route.testRoute2, .testRoute1, .testRoute2])

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute1, .testRoute2])
	}

	// MARK: - Push

	func testPush() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPush(.testRoute3)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute3])
	}

	func testMultiplePushs() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute2, .testRoute1])
	}

	// MARK: - Pop

	func testPopOnEmptyPath() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterAPush() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)

		sut.applyPop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterMultiplePushes() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)

		sut.applyPop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	// MARK: - PopToRoot

	func testPopToRootOnEmptyPath() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPopToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopToRootAfterAPush() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)

		sut.applyPopToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopToRootAfterMultiplePushes() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)
		sut.applyPush(.testRoute1)

		sut.applyPopToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	// MARK: - PopAfterIndex

	func testPopAfterNonNullIndexOnEmptyPath() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPopAfter(index: 2)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterNegativeIndex() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)

		sut.applyPopAfter(index: -1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute3])
	}

	func testPopAfterIndexMatchingPathCountMinusOne() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)

		sut.applyPopAfter(index: 1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	func testPopAfterIndexWithinPathCount() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)
		sut.applyPush(.testRoute1)
		sut.applyPush(.testRoute2)

		sut.applyPopAfter(index: 2)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute3])
	}

	func testPopAfterZeroIndex() throws {
		let sut = Router(root: .testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPush(.testRoute3)
		sut.applyPush(.testRoute1)

		sut.applyPopAfter(index: 0)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	// MARK: - Present

	func testPresentWithDefaultType() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPresent(.testRoute2)

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
		XCTAssertEqual(result[1].presentationType, .sheet)
		XCTAssertEqual(result[1].root, .testRoute2)
		XCTAssertEqual(result[1].routes, [])
	}

	func testPresentWithFullScreenType() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPresent(.testRoute2, type: .fullScreen)

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
		XCTAssertEqual(result[1].presentationType, .fullScreen)
		XCTAssertEqual(result[1].root, .testRoute2)
		XCTAssertEqual(result[1].routes, [])
	}

	func testPresentMultipleScreens() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPresent(.testRoute2, type: .sheet)
		sut.applyPresent(.testRoute2, type: .fullScreen)

		let result = sut.paths
		XCTAssertEqual(result.count, 3)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
		XCTAssertEqual(result[1].presentationType, .sheet)
		XCTAssertEqual(result[1].root, .testRoute2)
		XCTAssertEqual(result[1].routes, [])
		XCTAssertEqual(result[2].presentationType, .fullScreen)
		XCTAssertEqual(result[2].root, .testRoute2)
		XCTAssertEqual(result[2].routes, [])
	}

	func testPresentWithPopsInbetween() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPush(.testRoute2)
		sut.applyPresent(.testRoute2, type: .fullScreen)
		sut.applyPush(.testRoute3)

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [.testRoute2])
		XCTAssertEqual(result[1].presentationType, .fullScreen)
		XCTAssertEqual(result[1].root, .testRoute2)
		XCTAssertEqual(result[1].routes, [.testRoute3])
	}

	// MARK: - Dismiss

	func testDismissWithoutPresent() throws {
		let sut = Router(root: .testRoute1)

		sut.applyDismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
	}

	func testDismissAfterPresent() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPresent(.testRoute3)
		sut.applyDismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
	}

	func testDismissAfterMultiplePresents() throws {
		let sut = Router(root: .testRoute1)

		sut.applyPresent(.testRoute3)
		sut.applyPresent(.testRoute2)
		sut.applyDismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
		XCTAssertEqual(result[1].presentationType, .sheet)
		XCTAssertEqual(result[1].root, .testRoute3)
		XCTAssertEqual(result[1].routes, [])
	}

	func testDismissAfterMultiplePresentsWithPushes() throws {
		let sut = Router(root: .testRoute3)

		sut.applyPush(.testRoute2)
		sut.applyPresent(.testRoute3, type: .fullScreen)
		sut.applyPush(.testRoute1)
		sut.applyPush(.testRoute2)
		sut.applyPresent(.testRoute2, type: .fullScreen)
		sut.applyPush(.testRoute3)
		sut.applyDismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute3)
		XCTAssertEqual(result[0].routes, [.testRoute2])
		XCTAssertEqual(result[1].presentationType, .fullScreen)
		XCTAssertEqual(result[1].root, .testRoute3)
		XCTAssertEqual(result[1].routes, [.testRoute1, .testRoute2])
	}

	// MARK: - Binding

	func testBindingHasNoRetainCycle() throws {
		var sut: Router? = Router(root: .testRoute1)
		XCTAssertNotNil(sut)
		let binding = try XCTUnwrap(sut?.verticalBinding(index: 1))

		let info = binding.wrappedValue // Test that this is not causing a retain cycle
		XCTAssertNil(info)

		weak var weakSut: Router? = sut
		sut = nil

		XCTAssertNil(weakSut)
	}

	func testBindingReturnsActiveInfo() throws {
		let sut = Router(root: .testRoute1)
		let binding = sut.verticalBinding(index: 1)
		sut.paths.append(HorizontalPath(root: .testRoute2, presentationType: .fullScreen))

		let result = try XCTUnwrap(binding.wrappedValue)

		XCTAssertEqual(result.index, 1)
		XCTAssertEqual(result.presentationType, .fullScreen)
	}

	func testBindingReturnsNilForNotMatchingIndex() throws {
		let sut = Router(root: .testRoute1)
		let binding = sut.verticalBinding(index: 1)

		let result = binding.wrappedValue

		XCTAssertNil(result)
	}
}
