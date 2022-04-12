//
//  View+.swift
//  Dot
//
//  Created by Alex Nagy on 10.08.2021.
//

import SwiftUI

public extension View {
	/// Wraps the View in a NavigationView
	/// - Parameter style: the navigation style
	/// - Returns: A view embeded in a NavigationView with optional style
	@ViewBuilder
	func navigatable(style: NavigatableStyle = .none) -> some View {
		switch style {
		case .none:
			NavigationView { self }
		#if !os(macOS)
			case .stack:
				NavigationView { self }.navigationViewStyle(.stack)
		#endif
		case .automatic:
			NavigationView { self }.navigationViewStyle(.automatic)
		#if !os(tvOS) && !os(watchOS)
			case .columns:
				NavigationView { self }.navigationViewStyle(.columns)
		#endif
		}
	}

	/// Applies the given transform if the given condition evaluates to `true`.
	/// - Parameters:
	///   - condition: The condition to evaluate.
	///   - transform: The transform to apply to the source `View`.
	/// - Returns: Either the original `View` or the modified `View` if the condition is `true`.
	@ViewBuilder
	func `if`<Content: View>(_ condition: @autoclosure () -> Bool, transform: (Self) -> Content) -> some View {
		if condition() {
			transform(self)
		} else {
			self
		}
	}

	/// Configures the title display mode to `.inline` for this view and also configures the view's title for purposes of navigation, using a string.
	/// - Parameter title: The string to display.
	func navigationInlineTitle(_ title: String) -> some View {
		navigationTitle(title)
		#if !os(tvOS) && !os(macOS)
			.navigationBarTitleDisplayMode(.inline)
		#endif
	}
}
