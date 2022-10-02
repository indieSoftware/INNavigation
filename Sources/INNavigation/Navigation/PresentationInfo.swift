import Foundation

/// Information for a vertical navigation used by the presentation binding.
struct PresentationInfo {
	/// The depth of the vertical navigation stack
	/// reflecting the index of modally shown views this represents.
	let index: Int

	/// The type of presentation to use for the vertical navigation,
	/// e.g. full-screen or sheet.
	let presentationType: PresentationType

	/// A closure which gets called when the vertical navigation gets dismissed.
	let onDismiss: (() -> Void)?
}

extension PresentationInfo: Identifiable {
	var id: Int { index }
}
