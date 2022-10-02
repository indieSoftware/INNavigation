import SwiftUI

extension View {
	/// Adds support for a vertical navigation to a view with a router.
	/// This addes `sheet` and `fullScreenCover` modifier to the view handled by a router binding.
	func verticalNavigation<RouterType: Route>(
		for _: RouterType.Type,
		binding: Binding<PresentationInfo?>
	) -> some View {
		fullScreenCover(
			item: Binding<PresentationInfo?>(
				get: {
					guard binding.wrappedValue?.presentationType == .fullScreen else {
						return nil
					}
					return binding.wrappedValue
				}, set: { _ in }
			),
			onDismiss: binding.wrappedValue?.onDismiss,
			content: { presentationItem in
				RouterView<RouterType>(index: presentationItem.index)
			}
		)
		.sheet(
			item: Binding<PresentationInfo?>(
				get: {
					guard binding.wrappedValue?.presentationType == .sheet else {
						return nil
					}
					return binding.wrappedValue
				}, set: { _ in }
			),
			onDismiss: binding.wrappedValue?.onDismiss,
			content: { presentationItem in
				RouterView<RouterType>(index: presentationItem.index)
			}
		)
	}
}
