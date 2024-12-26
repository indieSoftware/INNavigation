import SwiftUI

/// This problem shows that the NavigationStack is not respecting the safeAreaInset.
/// The green view respects the safeAreaInset's red view, but not if embedded within
/// a NavigationStack, because then the green view covers the same space as the red view.
/// That makes it impossible to use the approach of using safeAreaInsets for `RouterView`.
struct Problem1View: View {
	@State var contentStep = 0

	var body: some View {
		ZStack {
			if contentStep == 0 {
				// Without NavigationStack
				Content(contentStep: $contentStep)
			} else {
				// Within NavigationStack
				NavigationStack {
					Content(contentStep: $contentStep)
				}
			}
		}
		// Adds the red bar to the top of the screen and extends the safe area by its size.
		.safeAreaInset(edge: .top, spacing: .zero) {
			Color.red.opacity(0.2).frame(height: 40)
		}
	}
}

private struct Content: View {
	@Binding var contentStep: Int

	var body: some View {
		ZStack {
			// A green background respecting the safe area.
			Color.green.opacity(0.3).border(.gray, width: 2)

			VStack {
				Text("Shows this content either witout or within a NavigationStack.")
				Picker("Step", selection: $contentStep) {
					Text("Without").tag(0)
					Text("Within").tag(1)
				}
				.pickerStyle(SegmentedPickerStyle())
				.padding()
			}
			.padding()
		}
	}
}
