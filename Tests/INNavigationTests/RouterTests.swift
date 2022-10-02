@testable import INNavigation
import SwiftUI
import XCTest

@MainActor
final class RouterTests: XCTestCase {
	// MARK: - Init

	func testInitProvidesRoot() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		let result = sut.paths

		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.routes.count, 0)
		XCTAssertEqual(path.root, .testRoute1)
	}

	// MARK: - NumberOfPushedViews

	func testNumberOfPushedViewsOnEmptyPath() {
		let sut = Router<TestRoute>(root: .testRoute1)
		let result = sut.numberOfPushedViews
		XCTAssertEqual(result, 0)
	}

	func testNumberOfPushedViewsOnExistingPath() {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)
		let result = sut.numberOfPushedViews
		XCTAssertEqual(result, 2)
	}

	// MARK: - Set

	func testSetWithOnePath() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.set(routes: .testRoute2)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	func testSetWithMultiplePaths() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.set(routes: .testRoute2, .testRoute1, .testRoute2)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute1, .testRoute2])
	}

	// MARK: - Push

	func testPush() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.push(.testRoute3)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute3])
	}

	func testMultiplePushs() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.push(.testRoute2)
		sut.push(.testRoute2)
		sut.push(.testRoute1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute2, .testRoute1])
	}

	// MARK: - Pop

	func testPopOnEmptyPath() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.pop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterAPush() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)

		sut.pop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterMultiplePushes() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)

		sut.pop()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	// MARK: - PopToRoot

	func testPopToRootOnEmptyPath() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.popToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopToRootAfterAPush() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)

		sut.popToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopToRootAfterMultiplePushes() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)
		sut.push(.testRoute1)

		sut.popToRoot()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	// MARK: - PopAfterIndex

	func testPopAfterNonNullIndexOnEmptyPath() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.popAfter(index: 2)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [])
	}

	func testPopAfterNegativeIndex() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)

		sut.popAfter(index: -1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute3])
	}

	func testPopAfterIndexMatchingPathCountMinusOne() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)

		sut.popAfter(index: 1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute3])
	}

	func testPopAfterIndexWithinPathCount() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)
		sut.push(.testRoute1)
		sut.push(.testRoute2)

		sut.popAfter(index: 1)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2, .testRoute3])
	}

	func testPopAfterZeroIndex() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		sut.push(.testRoute2)
		sut.push(.testRoute3)
		sut.push(.testRoute1)

		sut.popAfter(index: 0)

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		let path = try XCTUnwrap(result.first)
		XCTAssertEqual(path.root, .testRoute1)
		XCTAssertEqual(path.routes, [.testRoute2])
	}

	// MARK: - Present

	func testPresentWithDefaultType() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.present(.testRoute2)

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
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.present(.testRoute2, type: .fullScreen)

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
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.present(.testRoute2, type: .sheet)
		sut.present(.testRoute2, type: .fullScreen)

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
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.push(.testRoute2)
		sut.present(.testRoute2, type: .fullScreen)
		sut.push(.testRoute3)

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
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.dismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
	}

	func testDismissAfterPresent() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.present(.testRoute3)
		sut.dismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 1)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute1)
		XCTAssertEqual(result[0].routes, [])
	}

	func testDismissAfterMultiplePresents() throws {
		let sut = Router<TestRoute>(root: .testRoute1)

		sut.present(.testRoute3)
		sut.present(.testRoute2)
		sut.dismiss()

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
		let sut = Router<TestRoute>(root: .testRoute3)

		sut.push(.testRoute2)
		sut.present(.testRoute3, type: .fullScreen)
		sut.push(.testRoute1)
		sut.push(.testRoute2)
		sut.present(.testRoute2, type: .fullScreen)
		sut.push(.testRoute3)
		sut.dismiss()

		let result = sut.paths
		XCTAssertEqual(result.count, 2)
		XCTAssertEqual(result[0].presentationType, .fullScreen)
		XCTAssertEqual(result[0].root, .testRoute3)
		XCTAssertEqual(result[0].routes, [.testRoute2])
		XCTAssertEqual(result[1].presentationType, .fullScreen)
		XCTAssertEqual(result[1].root, .testRoute3)
		XCTAssertEqual(result[1].routes, [.testRoute1, .testRoute2])
	}

	// MARK: - ConsecutiveSteps

	func testConsecutiveSteps() throws {
		let sut = Router<TestRoute>(root: .testRoute3)

		let closuerExpectation = expectation(description: "closuerExpectation")
		sut.consecutiveSteps { router in
			router.push(.testRoute2)
			router.present(.testRoute3, type: .fullScreen)
			router.push(.testRoute1)
			router.push(.testRoute2)
			closuerExpectation.fulfill()
		}

		waitForExpectations(timeout: 1.0)

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
		var sut: Router<TestRoute>? = Router<TestRoute>(root: .testRoute1)
		XCTAssertNotNil(sut)
		let binding = try XCTUnwrap(sut?.verticalBinding(index: 1))

		let info = binding.wrappedValue // This can cause a retain cycle
		XCTAssertNil(info)

		weak var weakSut: Router<TestRoute>? = sut
		sut = nil

		XCTAssertNil(weakSut)
	}

	func testBindingReturnsActiveInfo() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		let binding = sut.verticalBinding(index: 1)
		sut.paths.append(HorizontalPath<TestRoute>(root: .testRoute2, presentationType: .fullScreen))

		let result = try XCTUnwrap(binding.wrappedValue)

		XCTAssertEqual(result.index, 1)
		XCTAssertEqual(result.presentationType, .fullScreen)
	}

	func testBindingReturnsNilForNotMatchingIndex() throws {
		let sut = Router<TestRoute>(root: .testRoute1)
		let binding = sut.verticalBinding(index: 1)

		let result = binding.wrappedValue

		XCTAssertNil(result)
	}
}
