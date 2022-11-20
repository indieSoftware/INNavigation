public extension Router {
	/// Performs multiple pop calls and waits between each step to have them animated.
	func multiPopToRoot() {
		Task {
			await multiPopToRoot()
		}
	}

	/// Performs multiple pop calls and waits between each step to have them animated.
	nonisolated func multiPopToRoot() async {
		while await numberOfPushedViews > 0 {
			await pop()
		}
	}

	/// Removes all vertical paths one after another animated.
	func multiDismissToRoot() {
		Task {
			await multiDismissToRoot()
		}
	}

	/// Removes all vertical paths one after another animated.
	nonisolated func multiDismissToRoot() async {
		while await numberOfPresentedViews > 1 {
			await dismiss()
		}
	}
}
