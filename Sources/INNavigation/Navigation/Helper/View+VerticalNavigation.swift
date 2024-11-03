import SwiftUI

extension View {
	/// Adds support for a vertical navigation to a view with a router.
	/// This addes `sheet` and `fullScreenCover` modifier to the view handled by a router binding.
	func verticalNavigation(
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
				RouterView(index: presentationItem.index)
			}
		)
		.sheet(
			item: Binding<PresentationInfo?>(
				get: {
                    guard let wrappedValue = binding.wrappedValue else {
                        return nil
                    }
                    switch wrappedValue.presentationType {
                    case .sheet:
                        return wrappedValue
                    case .fullScreen:
                        return nil
                    }
				}, set: { _ in }
			),
			onDismiss: binding.wrappedValue?.onDismiss,
			content: { presentationItem in
                switch presentationItem.presentationType {
                case .fullScreen:
                    RouterView(index: presentationItem.index)
                case .sheet(detents: let detents):
                    RouterView(index: presentationItem.index)
                        .presentationDetents(detents)
                }
            }
		)
	}
}
